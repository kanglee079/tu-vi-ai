package platform

import (
	"context"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5/middleware"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/redis/go-redis/v9"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
)

type Dependencies struct {
	Config config.Config
	Logger *slog.Logger
	DB     *pgxpool.Pool
	Redis  *redis.Client
}

func NewLogger(cfg config.Config) *slog.Logger {
	level := slog.LevelInfo
	if cfg.AppEnv != "production" {
		level = slog.LevelDebug
	}
	return slog.New(slog.NewJSONHandler(
		os.Stdout,
		&slog.HandlerOptions{Level: level},
	))
}

func NewPostgres(ctx context.Context, cfg config.Config) (*pgxpool.Pool, error) {
	if cfg.DatabaseURL == "" {
		return nil, nil
	}
	return pgxpool.New(ctx, cfg.DatabaseURL)
}

func NewRedis(cfg config.Config) *redis.Client {
	if cfg.RedisAddr == "" {
		return nil
	}
	return redis.NewClient(&redis.Options{
		Addr:     cfg.RedisAddr,
		Password: cfg.RedisPassword,
	})
}

type StubServices struct{}

func (StubServices) GetMe(ctx context.Context, firebaseUID string) (app.User, error) {
	if firebaseUID == "" {
		return app.User{}, ErrUnauthorized
	}
	return app.User{
		ID:          uuid.NewString(),
		FirebaseUID: firebaseUID,
		DisplayName: "Prototype User",
	}, nil
}

func (StubServices) DeleteMe(ctx context.Context, firebaseUID string) error { return nil }

func (StubServices) ListProfiles(ctx context.Context, firebaseUID string) ([]app.Profile, error) {
	return []app.Profile{}, nil
}

func (StubServices) CreateProfile(ctx context.Context, firebaseUID string, input app.CreateProfileInput) (app.Profile, error) {
	input.ID = uuid.NewString()
	return input, nil
}

func (StubServices) UpdateProfile(ctx context.Context, firebaseUID string, profileID string, input app.CreateProfileInput) (app.Profile, error) {
	input.ID = profileID
	return input, nil
}

func (StubServices) DeleteProfile(ctx context.Context, firebaseUID string, profileID string) error {
	return nil
}

func (StubServices) SetMain(ctx context.Context, firebaseUID string, profileID string) error {
	return nil
}

func (StubServices) UpsertChartSnapshot(ctx context.Context, firebaseUID string, input app.ChartSnapshotInput) (app.ChartSnapshot, error) {
	return app.ChartSnapshot{
		ID:            uuid.NewString(),
		ProfileID:     input.ProfileID,
		Year:          input.Year,
		EngineVersion: input.EngineVersion,
		SchemaVersion: input.SchemaVersion,
		SnapshotHash:  input.SnapshotHash,
		Payload:       input.Payload,
	}, nil
}

func (StubServices) GetChartSnapshot(ctx context.Context, firebaseUID string, profileID string, year int) (app.ChartSnapshot, error) {
	return app.ChartSnapshot{
		ID:            uuid.NewString(),
		ProfileID:     profileID,
		Year:          year,
		EngineVersion: "flutter-authoritative-v1",
		SchemaVersion: "chart_snapshot_v1",
		SnapshotHash:  "stub",
		Payload:       json.RawMessage(`{}`),
	}, nil
}

func (StubServices) Chat(ctx context.Context, firebaseUID string, input app.AIChatInput) (app.AIChatOutput, error) {
	return app.AIChatOutput{
		Title:           "AI backend stub",
		ShortAnswer:     "Structured-output endpoint scaffolded; OpenAI call not wired in this workspace yet.",
		SummaryBullets:  []string{"Profile accepted", "Snapshot accepted", "Provider boundary ready"},
		DetailedReading: "The backend contract is in place for chart snapshot driven AI responses.",
		Evidence:        []app.AIEvidence{{Factor: "chartSnapshotHash", Meaning: input.ChartSnapshotHash, Impact: "medium"}},
		PracticalAdvice: []string{"Wire OpenAI key", "Persist knowledge rules", "Add provider retry"},
		Avoid:           []string{"Inline prompt sprawl"},
		NextSuggestions: []string{"Connect OpenAI", "Persist requests"},
		Disclaimer:      "Nội dung mang tính tham khảo.",
	}, nil
}

func (StubServices) GetWallet(ctx context.Context, firebaseUID string) (app.WalletSnapshot, error) {
	return app.WalletSnapshot{Balance: 0, History: []app.WalletLedgerEntry{}, ActivePlanLabel: ""}, nil
}

func (StubServices) ListLedger(ctx context.Context, firebaseUID string) ([]app.WalletLedgerEntry, error) {
	return []app.WalletLedgerEntry{}, nil
}

func (StubServices) Spend(ctx context.Context, firebaseUID string, input app.WalletSpendInput) (app.WalletSnapshot, error) {
	return app.WalletSnapshot{}, nil
}

func (StubServices) VerifyApple(ctx context.Context, firebaseUID string, input app.PurchaseVerifyInput) (app.PurchaseVerifyOutput, error) {
	return app.PurchaseVerifyOutput{Verified: false}, nil
}

func (StubServices) VerifyGoogle(ctx context.Context, firebaseUID string, input app.PurchaseVerifyInput) (app.PurchaseVerifyOutput, error) {
	return app.PurchaseVerifyOutput{Verified: false}, nil
}

func (StubServices) HandleAppleNotification(ctx context.Context, payload json.RawMessage) error {
	return nil
}

func (StubServices) HandleGoogleRTDN(ctx context.Context, payload json.RawMessage) error {
	return nil
}

func (StubServices) ListArticles(ctx context.Context) ([]app.Article, error) {
	return []app.Article{}, nil
}

func (StubServices) GetArticleBySlug(ctx context.Context, slug string) (app.Article, error) {
	return app.Article{}, nil
}

func (StubServices) Load(ctx context.Context, key string) (app.IdempotencyResult, bool, error) {
	return app.IdempotencyResult{}, false, nil
}

func (StubServices) Store(ctx context.Context, key string, result app.IdempotencyResult) error {
	return nil
}

func RequestContext(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.RequestIDKey, middleware.GetReqID(r.Context()))
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func AuthContext(firebaseProjectID string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			firebaseUID := r.Header.Get("X-Debug-Firebase-Uid")
			if firebaseUID == "" {
				firebaseUID = "guest_debug_uid"
			}
			next.ServeHTTP(w, r.WithContext(context.WithValue(r.Context(), firebaseUIDContextKey, firebaseUID)))
		})
	}
}

type authContextKey string

const firebaseUIDContextKey authContextKey = "firebase_uid"

var ErrUnauthorized = errors.New("unauthorized")

func FirebaseUIDFromContext(ctx context.Context) string {
	value, _ := ctx.Value(firebaseUIDContextKey).(string)
	return value
}

func NewHTTPServer(cfg config.Config, application app.App) *http.Server {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_ = application
		w.WriteHeader(http.StatusNotImplemented)
	})
	return &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           handler,
		ReadHeaderTimeout: 10 * time.Second,
	}
}
