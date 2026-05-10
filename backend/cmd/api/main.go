package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
	httplayer "minh_menh_ai/backend/internal/http"
	"minh_menh_ai/backend/internal/platform"
)

func main() {
	cfg := config.Load()
	logger := log.New(os.Stdout, "", log.LstdFlags|log.LUTC)

	ctx := context.Background()

	// Skip DB connection entirely if forced to stub (e.g. network unreachable)
	var db *pgxpool.Pool
	var err error
	if !cfg.ForceStubServices && cfg.DatabaseURL != "" {
		db, err = platform.NewPostgres(ctx, cfg)
		if err != nil {
			logger.Fatalf("failed to connect to postgres: %v", err)
		}
		if db != nil {
			defer db.Close()
		}
	}

	redisClient := platform.NewRedis(cfg)

	aiService := platform.NewOpenAIResponsesService(cfg)
	iapService := platform.NewIAPVerificationService(cfg)
	tokenVerifier := platform.NewFirebaseTokenVerifier(cfg.FirebaseProjectID)

	// Wire real services only when DB is available; otherwise fall back to stubs
	var profileService app.ProfileService
	var userService app.UserService
	var walletService app.WalletService
	var articleService app.ArticleService
	var idempotentService app.IdempotencyService

	if db != nil && !cfg.ForceStubServices {
		userService = platform.NewUserService(db)
		profileService = platform.NewProfileService(db)
		walletService = platform.NewWalletService(db)
		articleService = platform.NewArticleService(db)
		idempotentService = platform.NewIdempotencyService(db)
		logger.Printf("real postgres connected, real services wired")
	} else {
		stub := platform.StubServices{}
		userService = stub
		profileService = stub
		walletService = stub
		articleService = stub
		idempotentService = stub
		if cfg.ForceStubServices {
			logger.Printf("FORCE_STUB_SERVICES=true, using stub services (db unreachable)")
		} else {
			logger.Printf("no DATABASE_URL, using stub services")
		}
	}

	application := app.App{
		Clock:        time.Now,
		Profiles:     profileService,
		Users:        userService,
		AI:           aiService,
		Wallet:       walletService,
		IAP:          iapService,
		Articles:     articleService,
		Idempotent:   idempotentService,
	}

	router := httplayer.NewRouter(
		httplayer.Server{
			App:         application,
			RequireAuth: httplayer.BearerAuthMiddleware(tokenVerifier.Verify, cfg.AuthAllowDebug),
			Products:    cfg.IAPProducts,
		},
	)
	server := &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           router,
		ReadHeaderTimeout: 10 * time.Second,
	}

	go func() {
		logger.Printf("api listening on :%s", cfg.Port)
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatalf("server failed: %v", err)
		}
	}()

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)
	<-stop

	logger.Printf("shutting down...")
	shutdownCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if err := server.Shutdown(shutdownCtx); err != nil {
		logger.Printf("shutdown error: %v", err)
	}
	_ = redisClient
}
