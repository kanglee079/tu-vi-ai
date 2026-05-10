package config

import (
	"bufio"
	"encoding/json"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

type Config struct {
	AppEnv            string
	Port              string
	DatabaseURL       string
	RedisAddr         string
	RedisPassword     string
	OpenAIAPIKey      string
	OpenAIBaseURL     string
	OpenAIModel       string
	FirebaseProjectID string
	AuthAllowDebug     bool
	ForceStubServices  bool
	AppleBundleID     string
	AppleIssuerID     string
	AppleKeyID        string
	ApplePrivateKey   string
	AppleEnvironment  string
	GooglePackageName string
	GoogleServiceJSON string
	IAPProducts       []IAPProduct
	RequestTimeoutSec int
}

type IAPProduct struct {
	ID            string `json:"id"`
	Kind          string `json:"kind"`
	Title         string `json:"title"`
	WalletDelta   int    `json:"walletDelta"`
	Entitlement   string `json:"entitlement"`
	PriceTierNote string `json:"priceTierNote,omitempty"`
}

func Load() Config {
	loadDotEnvFiles(".env", filepath.Join("backend", ".env"))

	return Config{
		AppEnv:            getEnv("APP_ENV", "development"),
		Port:              getEnv("PORT", "8080"),
		DatabaseURL:       getEnv("DATABASE_URL", ""),
		RedisAddr:         getEnv("REDIS_ADDR", ""),
		RedisPassword:     getEnv("REDIS_PASSWORD", ""),
		OpenAIAPIKey:      getSecret("OPENAI_API_KEY", "OPENAI_API_KEY_FILE"),
		OpenAIBaseURL:     getEnv("OPENAI_BASE_URL", "https://api.openai.com/v1"),
		OpenAIModel:       getEnv("OPENAI_MODEL", "gpt-4.1-mini"),
		FirebaseProjectID: getEnv("FIREBASE_PROJECT_ID", ""),
		AuthAllowDebug:     getEnvBool("AUTH_ALLOW_DEBUG_BYPASS", false),
		ForceStubServices:  getEnvBool("FORCE_STUB_SERVICES", false),
		AppleBundleID:     getEnv("APPLE_BUNDLE_ID", ""),
		AppleIssuerID:     getEnv("APPLE_ISSUER_ID", ""),
		AppleKeyID:        getEnv("APPLE_KEY_ID", ""),
		ApplePrivateKey:   normalizePEM(getSecret("APPLE_PRIVATE_KEY_P8", "APPLE_PRIVATE_KEY_P8_FILE")),
		AppleEnvironment:  getEnv("APPLE_ENVIRONMENT", "sandbox"),
		GooglePackageName: getEnv("GOOGLE_PACKAGE_NAME", ""),
		GoogleServiceJSON: getSecret("GOOGLE_SERVICE_ACCOUNT_JSON", "GOOGLE_SERVICE_ACCOUNT_JSON_FILE"),
		IAPProducts:       getIAPProducts(),
		RequestTimeoutSec: getEnvInt("REQUEST_TIMEOUT_SEC", 30),
	}
}

func (c Config) IAPProductByID(productID string) (IAPProduct, bool) {
	for _, product := range c.IAPProducts {
		if product.ID == productID {
			return product, true
		}
	}
	return IAPProduct{}, false
}

func getEnv(key string, fallback string) string {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	return value
}

func getSecret(key string, fileKey string) string {
	if value := strings.TrimSpace(os.Getenv(key)); value != "" {
		return value
	}
	path := strings.TrimSpace(os.Getenv(fileKey))
	if path == "" {
		return ""
	}
	raw, err := os.ReadFile(path)
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(raw))
}

func getEnvInt(key string, fallback int) int {
	raw := os.Getenv(key)
	if raw == "" {
		return fallback
	}
	value, err := strconv.Atoi(raw)
	if err != nil {
		return fallback
	}
	return value
}

func getEnvBool(key string, fallback bool) bool {
	raw := strings.TrimSpace(os.Getenv(key))
	if raw == "" {
		return fallback
	}
	value, err := strconv.ParseBool(raw)
	if err != nil {
		return fallback
	}
	return value
}

func getIAPProducts() []IAPProduct {
	raw := strings.TrimSpace(os.Getenv("IAP_PRODUCT_CATALOG_JSON"))
	if raw == "" {
		return defaultIAPProducts()
	}
	var products []IAPProduct
	if err := json.Unmarshal([]byte(raw), &products); err != nil || len(products) == 0 {
		return defaultIAPProducts()
	}
	return products
}

func defaultIAPProducts() []IAPProduct {
	return []IAPProduct{
		{
			ID:            "coin_100",
			Kind:          "consumable",
			Title:         "100 xu",
			WalletDelta:   100,
			PriceTierNote: "VND 29,000 target",
		},
		{
			ID:            "coin_300",
			Kind:          "consumable",
			Title:         "300 xu",
			WalletDelta:   300,
			PriceTierNote: "VND 79,000 target",
		},
		{
			ID:            "sub_month",
			Kind:          "subscription",
			Title:         "Gói tháng",
			Entitlement:   "ai_monthly",
			PriceTierNote: "VND 199,000/month target",
		},
	}
}

func normalizePEM(value string) string {
	return strings.ReplaceAll(value, `\n`, "\n")
}

func loadDotEnvFiles(paths ...string) {
	for _, path := range paths {
		loadDotEnv(path)
	}
}

func loadDotEnv(path string) {
	file, err := os.Open(path)
	if err != nil {
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		line = strings.TrimPrefix(line, "export ")
		key, value, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		key = strings.TrimSpace(key)
		if key == "" || os.Getenv(key) != "" {
			continue
		}
		_ = os.Setenv(key, trimEnvValue(value))
	}
}

func trimEnvValue(value string) string {
	value = strings.TrimSpace(value)
	if len(value) >= 2 {
		if (value[0] == '"' && value[len(value)-1] == '"') ||
			(value[0] == '\'' && value[len(value)-1] == '\'') {
			return value[1 : len(value)-1]
		}
	}
	return value
}
