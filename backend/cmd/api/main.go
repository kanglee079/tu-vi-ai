package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
	httplayer "minh_menh_ai/backend/internal/http"
	"minh_menh_ai/backend/internal/platform"
)

func main() {
	cfg := config.Load()
	logger := log.New(os.Stdout, "", log.LstdFlags|log.LUTC)

	ctx := context.Background()
	stub := platform.StubServices{}
	aiService := platform.NewOpenAIResponsesService(cfg)
	iapService := platform.NewIAPVerificationService(cfg)
	tokenVerifier := platform.NewFirebaseTokenVerifier(cfg.FirebaseProjectID)
	application := app.App{
		Clock:      time.Now,
		Profiles:   stub,
		Users:      stub,
		AI:         aiService,
		Wallet:     stub,
		IAP:        iapService,
		Articles:   stub,
		Idempotent: stub,
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

	shutdownCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if err := server.Shutdown(shutdownCtx); err != nil {
		logger.Printf("shutdown error: %v", err)
	}
}
