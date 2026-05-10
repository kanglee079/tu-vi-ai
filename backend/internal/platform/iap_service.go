package platform

import (
	"bytes"
	"context"
	"crypto"
	"crypto/ecdsa"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/oauth2/google"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
)

type IAPVerificationService struct {
	config     config.Config
	httpClient *http.Client
}

func NewIAPVerificationService(cfg config.Config) *IAPVerificationService {
	return &IAPVerificationService{
		config:     cfg,
		httpClient: &http.Client{Timeout: 20 * time.Second},
	}
}

func (s *IAPVerificationService) VerifyApple(
	ctx context.Context,
	firebaseUID string,
	input app.PurchaseVerifyInput,
) (app.PurchaseVerifyOutput, error) {
	if firebaseUID == "" {
		return app.PurchaseVerifyOutput{}, ErrUnauthorized
	}
	product, ok := s.config.IAPProductByID(input.ProductID)
	if !ok {
		return app.PurchaseVerifyOutput{}, fmt.Errorf("unknown productId: %s", input.ProductID)
	}
	if input.TransactionID == "" {
		return app.PurchaseVerifyOutput{}, errors.New("apple transactionId is required")
	}
	if s.config.AppleBundleID == "" ||
		s.config.AppleIssuerID == "" ||
		s.config.AppleKeyID == "" ||
		s.config.ApplePrivateKey == "" {
		return app.PurchaseVerifyOutput{}, errors.New("apple verification secrets are not configured")
	}
	token, err := s.appleJWT()
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	host := "https://api.storekit.itunes.apple.com"
	if strings.EqualFold(s.config.AppleEnvironment, "sandbox") {
		host = "https://api.storekit-sandbox.itunes.apple.com"
	}
	endpoint := fmt.Sprintf("%s/inApps/v1/transactions/%s", host, url.PathEscape(input.TransactionID))
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	req.Header.Set("Authorization", "Bearer "+token)
	resp, err := s.httpClient.Do(req)
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	defer resp.Body.Close()
	if resp.StatusCode >= 400 {
		return app.PurchaseVerifyOutput{}, fmt.Errorf("apple verify failed: %s", resp.Status)
	}
	return app.PurchaseVerifyOutput{
		Verified:     true,
		Entitlements: productEntitlements(product),
		WalletDelta:  product.WalletDelta,
	}, nil
}

func (s *IAPVerificationService) VerifyGoogle(
	ctx context.Context,
	firebaseUID string,
	input app.PurchaseVerifyInput,
) (app.PurchaseVerifyOutput, error) {
	if firebaseUID == "" {
		return app.PurchaseVerifyOutput{}, ErrUnauthorized
	}
	product, ok := s.config.IAPProductByID(input.ProductID)
	if !ok {
		return app.PurchaseVerifyOutput{}, fmt.Errorf("unknown productId: %s", input.ProductID)
	}
	if input.ProductID == "" || input.PurchaseToken == "" {
		return app.PurchaseVerifyOutput{}, errors.New("google productId and purchaseToken are required")
	}
	if s.config.GoogleServiceJSON == "" || s.config.GooglePackageName == "" {
		return app.PurchaseVerifyOutput{}, errors.New("google verification secrets are not configured")
	}
	credentials, err := google.CredentialsFromJSON(
		ctx,
		[]byte(s.config.GoogleServiceJSON),
		"https://www.googleapis.com/auth/androidpublisher",
	)
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	accessToken, err := credentials.TokenSource.Token()
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	endpoint := fmt.Sprintf(
		"https://androidpublisher.googleapis.com/androidpublisher/v3/applications/%s/purchases/products/%s/tokens/%s",
		url.PathEscape(s.config.GooglePackageName),
		url.PathEscape(input.ProductID),
		url.PathEscape(input.PurchaseToken),
	)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	req.Header.Set("Authorization", "Bearer "+accessToken.AccessToken)
	resp, err := s.httpClient.Do(req)
	if err != nil {
		return app.PurchaseVerifyOutput{}, err
	}
	defer resp.Body.Close()
	if resp.StatusCode >= 400 {
		return app.PurchaseVerifyOutput{}, fmt.Errorf("google verify failed: %s", resp.Status)
	}
	return app.PurchaseVerifyOutput{
		Verified:     true,
		Entitlements: productEntitlements(product),
		WalletDelta:  product.WalletDelta,
	}, nil
}

func productEntitlements(product config.IAPProduct) []string {
	if product.Entitlement != "" {
		return []string{product.Entitlement}
	}
	return []string{product.ID}
}

func (s *IAPVerificationService) HandleAppleNotification(
	ctx context.Context,
	payload json.RawMessage,
) error {
	if len(payload) == 0 {
		return errors.New("apple notification payload is empty")
	}
	return nil
}

func (s *IAPVerificationService) HandleGoogleRTDN(
	ctx context.Context,
	payload json.RawMessage,
) error {
	if len(payload) == 0 {
		return errors.New("google RTDN payload is empty")
	}
	return nil
}

func (s *IAPVerificationService) appleJWT() (string, error) {
	block, _ := pem.Decode([]byte(s.config.ApplePrivateKey))
	if block == nil {
		return "", errors.New("invalid APPLE_PRIVATE_KEY_P8 pem")
	}
	parsedKey, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		return "", err
	}
	privateKey, ok := parsedKey.(*ecdsa.PrivateKey)
	if !ok {
		return "", errors.New("apple private key is not ECDSA")
	}
	now := time.Now()
	token := jwt.NewWithClaims(jwt.SigningMethodES256, jwt.MapClaims{
		"iss": s.config.AppleIssuerID,
		"iat": now.Unix(),
		"exp": now.Add(30 * time.Minute).Unix(),
		"aud": "appstoreconnect-v1",
		"bid": s.config.AppleBundleID,
	})
	token.Header["kid"] = s.config.AppleKeyID
	token.Header["typ"] = "JWT"
	return token.SignedString(privateKey)
}

func basicAuthorizationHeader(secret string) string {
	return "Basic " + base64.StdEncoding.EncodeToString([]byte(secret))
}

func signPayload(privateKey *ecdsa.PrivateKey, payload []byte) ([]byte, error) {
	hash := crypto.SHA256.New()
	hash.Write(payload)
	digest := hash.Sum(nil)
	r, sValue, err := ecdsa.Sign(bytes.NewReader(digest), privateKey, digest)
	if err != nil {
		return nil, err
	}
	result := append(r.Bytes(), sValue.Bytes()...)
	return result, nil
}
