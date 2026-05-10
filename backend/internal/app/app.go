package app

import (
	"context"
	"encoding/json"
	"time"
)

type App struct {
	Clock      func() time.Time
	Profiles   ProfileService
	Users      UserService
	AI         AIService
	Wallet     WalletService
	IAP        IAPService
	Articles   ArticleService
	Idempotent IdempotencyService
}

type UserService interface {
	GetMe(ctx context.Context, firebaseUID string) (User, error)
	DeleteMe(ctx context.Context, firebaseUID string) error
}

type ProfileService interface {
	ListProfiles(ctx context.Context, firebaseUID string) ([]Profile, error)
	CreateProfile(ctx context.Context, firebaseUID string, input CreateProfileInput) (Profile, error)
	UpdateProfile(ctx context.Context, firebaseUID string, profileID string, input CreateProfileInput) (Profile, error)
	DeleteProfile(ctx context.Context, firebaseUID string, profileID string) error
	SetMain(ctx context.Context, firebaseUID string, profileID string) error
	UpsertChartSnapshot(ctx context.Context, firebaseUID string, input ChartSnapshotInput) (ChartSnapshot, error)
	GetChartSnapshot(ctx context.Context, firebaseUID string, profileID string, year int) (ChartSnapshot, error)
}

type AIService interface {
	Chat(ctx context.Context, firebaseUID string, input AIChatInput) (AIChatOutput, error)
}

type WalletService interface {
	GetWallet(ctx context.Context, firebaseUID string) (WalletSnapshot, error)
	ListLedger(ctx context.Context, firebaseUID string) ([]WalletLedgerEntry, error)
	Spend(ctx context.Context, firebaseUID string, input WalletSpendInput) (WalletSnapshot, error)
}

type IAPService interface {
	VerifyApple(ctx context.Context, firebaseUID string, input PurchaseVerifyInput) (PurchaseVerifyOutput, error)
	VerifyGoogle(ctx context.Context, firebaseUID string, input PurchaseVerifyInput) (PurchaseVerifyOutput, error)
	HandleAppleNotification(ctx context.Context, payload json.RawMessage) error
	HandleGoogleRTDN(ctx context.Context, payload json.RawMessage) error
}

type ArticleService interface {
	ListArticles(ctx context.Context) ([]Article, error)
	GetArticleBySlug(ctx context.Context, slug string) (Article, error)
}

type IdempotencyService interface {
	Load(ctx context.Context, key string) (IdempotencyResult, bool, error)
	Store(ctx context.Context, key string, result IdempotencyResult) error
}

type User struct {
	ID          string `json:"id"`
	FirebaseUID string `json:"firebaseUid"`
	Email       string `json:"email,omitempty"`
	DisplayName string `json:"displayName,omitempty"`
}

type Profile struct {
	ID                  string          `json:"id"`
	Name                string          `json:"name"`
	Gender              string          `json:"gender"`
	CalendarType        string          `json:"calendarType"`
	BirthDate           string          `json:"birthDate"`
	BirthHourLabel      string          `json:"birthHourLabel"`
	BirthMinute         *int            `json:"birthMinute,omitempty"`
	BirthPlace          string          `json:"birthPlace,omitempty"`
	Timezone            string          `json:"timezone"`
	BirthTimeConfidence string          `json:"birthTimeConfidence"`
	MainFocus           json.RawMessage `json:"mainFocus"`
	IsMain              bool            `json:"isMain"`
}

type CreateProfileInput = Profile

type ChartSnapshot struct {
	ID            string          `json:"id"`
	ProfileID     string          `json:"profileId"`
	Year          int             `json:"year"`
	EngineVersion string          `json:"engineVersion"`
	SchemaVersion string          `json:"schemaVersion"`
	SnapshotHash  string          `json:"snapshotHash"`
	Payload       json.RawMessage `json:"payload"`
}

type ChartSnapshotInput struct {
	ProfileID     string          `json:"profileId"`
	Year          int             `json:"year"`
	EngineVersion string          `json:"engineVersion"`
	SchemaVersion string          `json:"schemaVersion"`
	SnapshotHash  string          `json:"snapshotHash"`
	Payload       json.RawMessage `json:"payload"`
}

type AIChatInput struct {
	ProfileID         string          `json:"profileId"`
	Scope             string          `json:"scope"`
	Question          string          `json:"question"`
	ChartSnapshotID   string          `json:"chartSnapshotId,omitempty"`
	ChartSnapshotHash string          `json:"chartSnapshotHash,omitempty"`
	ChartSummary      json.RawMessage `json:"chartSummary,omitempty"`
}

type AIChatOutput struct {
	Title           string         `json:"title"`
	ShortAnswer     string         `json:"shortAnswer"`
	SummaryBullets  []string       `json:"summaryBullets"`
	DetailedReading string         `json:"detailedReading"`
	Evidence        []AIEvidence   `json:"evidence"`
	PracticalAdvice []string       `json:"practicalAdvice"`
	Avoid           []string       `json:"avoid"`
	NextSuggestions []string       `json:"nextSuggestions"`
	Disclaimer      string         `json:"disclaimer"`
}

type AIEvidence struct {
	Factor  string `json:"factor"`
	Meaning string `json:"meaning"`
	Impact  string `json:"impact"`
}

type WalletSnapshot struct {
	Balance         int                 `json:"balance"`
	History         []WalletLedgerEntry `json:"history"`
	ActivePlanLabel string              `json:"activePlanLabel"`
}

type WalletLedgerEntry struct {
	Title          string `json:"title"`
	Amount         int    `json:"amount"`
	CreatedAtLabel string `json:"createdAtLabel"`
}

type WalletSpendInput struct {
	ProfileID   string `json:"profileId"`
	ContentKey  string `json:"contentKey"`
	ContentType string `json:"contentType"`
	Amount      int    `json:"amount"`
}

type PurchaseVerifyInput struct {
	ProductID      string          `json:"productId"`
	TransactionID  string          `json:"transactionId,omitempty"`
	PurchaseToken  string          `json:"purchaseToken,omitempty"`
	ReceiptPayload json.RawMessage `json:"receiptPayload,omitempty"`
}

type PurchaseVerifyOutput struct {
	Verified     bool     `json:"verified"`
	Entitlements []string `json:"entitlements"`
	WalletDelta  int      `json:"walletDelta"`
}

type Article struct {
	ID       string          `json:"id"`
	Slug     string          `json:"slug"`
	Category string          `json:"category"`
	Title    string          `json:"title"`
	Summary  string          `json:"summary"`
	Body     json.RawMessage `json:"body"`
}

type IdempotencyResult struct {
	StatusCode int             `json:"statusCode"`
	Body       json.RawMessage `json:"body"`
}
