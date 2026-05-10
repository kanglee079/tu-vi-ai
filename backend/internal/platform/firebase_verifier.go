package platform

import (
	"context"
	"crypto/rsa"
	"crypto/x509"
	"encoding/json"
	"encoding/pem"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/golang-jwt/jwt/v5"

	"minh_menh_ai/backend/internal/app"
)

const firebaseJWKSURL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

type FirebaseTokenVerifier struct {
	projectID   string
	httpClient  *http.Client
	mu          sync.RWMutex
	cachedKeys  map[string]*rsa.PublicKey
	cachedUntil time.Time
}

func NewFirebaseTokenVerifier(projectID string) *FirebaseTokenVerifier {
	return &FirebaseTokenVerifier{
		projectID:  projectID,
		httpClient: &http.Client{Timeout: 10 * time.Second},
		cachedKeys: map[string]*rsa.PublicKey{},
	}
}

func (v *FirebaseTokenVerifier) Verify(
	ctx context.Context,
	idToken string,
) (app.User, error) {
	if v.projectID == "" {
		return app.User{}, ErrUnauthorized
	}
	keys, err := v.keys(ctx)
	if err != nil {
		return app.User{}, err
	}
	claims := jwt.MapClaims{}
	token, err := jwt.ParseWithClaims(
		idToken,
		claims,
		func(token *jwt.Token) (any, error) {
			if token.Method.Alg() != jwt.SigningMethodRS256.Alg() {
				return nil, fmt.Errorf("unexpected signing method: %s", token.Method.Alg())
			}
			kid, _ := token.Header["kid"].(string)
			publicKey, ok := keys[kid]
			if !ok {
				return nil, fmt.Errorf("firebase cert kid not found")
			}
			return publicKey, nil
		},
		jwt.WithIssuer("https://securetoken.google.com/"+v.projectID),
		jwt.WithAudience(v.projectID),
	)
	if err != nil || !token.Valid {
		return app.User{}, ErrUnauthorized
	}
	subject, _ := claims.GetSubject()
	if subject == "" {
		return app.User{}, ErrUnauthorized
	}
	return app.User{
		ID:          subject,
		FirebaseUID: subject,
		Email:       stringClaim(claims, "email"),
		DisplayName: stringClaim(claims, "name"),
	}, nil
}

func (v *FirebaseTokenVerifier) keys(ctx context.Context) (map[string]*rsa.PublicKey, error) {
	v.mu.RLock()
	if time.Now().Before(v.cachedUntil) && len(v.cachedKeys) > 0 {
		defer v.mu.RUnlock()
		return v.cachedKeys, nil
	}
	v.mu.RUnlock()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, firebaseJWKSURL, nil)
	if err != nil {
		return nil, err
	}
	resp, err := v.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode >= 400 {
		return nil, fmt.Errorf("firebase cert fetch failed: %s", resp.Status)
	}
	var raw map[string]string
	if err := json.NewDecoder(resp.Body).Decode(&raw); err != nil {
		return nil, err
	}
	keys := make(map[string]*rsa.PublicKey, len(raw))
	for kid, certPEM := range raw {
		block, _ := pem.Decode([]byte(certPEM))
		if block == nil {
			return nil, errors.New("invalid firebase cert pem")
		}
		cert, err := x509.ParseCertificate(block.Bytes)
		if err != nil {
			return nil, err
		}
		publicKey, ok := cert.PublicKey.(*rsa.PublicKey)
		if !ok {
			return nil, errors.New("firebase cert public key is not rsa")
		}
		keys[kid] = publicKey
	}
	cacheUntil := time.Now().Add(1 * time.Hour)
	if cacheControl := resp.Header.Get("Cache-Control"); cacheControl != "" {
		if maxAge := parseMaxAge(cacheControl); maxAge > 0 {
			cacheUntil = time.Now().Add(maxAge)
		}
	}
	v.mu.Lock()
	v.cachedKeys = keys
	v.cachedUntil = cacheUntil
	v.mu.Unlock()
	return keys, nil
}

func parseMaxAge(cacheControl string) time.Duration {
	parts := strings.Split(cacheControl, ",")
	for _, part := range parts {
		part = strings.TrimSpace(part)
		if strings.HasPrefix(part, "max-age=") {
			value := strings.TrimPrefix(part, "max-age=")
			if seconds, err := time.ParseDuration(value + "s"); err == nil {
				return seconds
			}
		}
	}
	return 0
}

func stringClaim(claims jwt.MapClaims, key string) string {
	value, _ := claims[key].(string)
	return value
}
