package http

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/go-chi/chi/v5"
	chimiddleware "github.com/go-chi/chi/v5/middleware"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
)

type Server struct {
	App         app.App
	RequireAuth func(http.Handler) http.Handler
	Products    []config.IAPProduct
}

func NewRouter(server Server) http.Handler {
	router := chi.NewRouter()
	router.Use(chimiddleware.RequestID)
	router.Use(chimiddleware.RealIP)
	router.Use(chimiddleware.Recoverer)
	router.Use(chimiddleware.Timeout(30 * time.Second))
	router.Get("/healthz", server.handleHealth)
	router.Get("/readyz", server.handleReady)

	router.Route("/v1", func(r chi.Router) {
		r.Get("/products", server.handleProducts)
		r.Get("/articles", server.handleArticles)
		r.Get("/articles/{slug}", server.handleArticleDetail)

		r.Post("/iap/apple/notifications", server.handleAppleNotifications)
		r.Post("/iap/google/rtdn", server.handleGoogleRTDN)

		r.Group(func(authed chi.Router) {
			if server.RequireAuth != nil {
				authed.Use(server.RequireAuth)
			} else {
				authed.Use(debugAuthContext)
			}
			authed.Get("/me", server.handleGetMe)
			authed.Delete("/me", server.handleDeleteMe)

			authed.Get("/profiles", server.handleListProfiles)
			authed.Post("/profiles", server.handleCreateProfile)
			authed.Patch("/profiles/{profileId}", server.handleUpdateProfile)
			authed.Delete("/profiles/{profileId}", server.handleDeleteProfile)
			authed.Post("/profiles/{profileId}:set-main", server.handleSetMainProfile)

			authed.Post("/chart-snapshots", server.handleUpsertChartSnapshot)
			authed.Get("/chart-snapshots/{profileId}/{year}", server.handleGetChartSnapshot)

			authed.Post("/ai/chat", server.handleAIChat)

			authed.Get("/wallet", server.handleWallet)
			authed.Get("/wallet/ledger", server.handleWalletLedger)
			authed.Post("/wallet/spend", server.handleWalletSpend)

			authed.Post("/iap/apple/verify", server.handleVerifyApple)
			authed.Post("/iap/google/verify", server.handleVerifyGoogle)
		})
	})

	return router
}

func (s Server) handleHealth(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

func (s Server) handleReady(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ready"})
}

func (s Server) handleGetMe(w http.ResponseWriter, r *http.Request) {
	user, err := s.App.Users.GetMe(r.Context(), firebaseUIDFromContext(r.Context()))
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, user)
}

func (s Server) handleDeleteMe(w http.ResponseWriter, r *http.Request) {
	if err := s.App.Users.DeleteMe(r.Context(), firebaseUIDFromContext(r.Context())); err != nil {
		writeError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (s Server) handleListProfiles(w http.ResponseWriter, r *http.Request) {
	items, err := s.App.Profiles.ListProfiles(r.Context(), firebaseUIDFromContext(r.Context()))
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, items)
}

func (s Server) handleCreateProfile(w http.ResponseWriter, r *http.Request) {
	var input app.CreateProfileInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	item, err := s.App.Profiles.CreateProfile(r.Context(), firebaseUIDFromContext(r.Context()), input)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, item)
}

func (s Server) handleUpdateProfile(w http.ResponseWriter, r *http.Request) {
	var input app.CreateProfileInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	item, err := s.App.Profiles.UpdateProfile(
		r.Context(),
		firebaseUIDFromContext(r.Context()),
		chi.URLParam(r, "profileId"),
		input,
	)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func (s Server) handleDeleteProfile(w http.ResponseWriter, r *http.Request) {
	err := s.App.Profiles.DeleteProfile(
		r.Context(),
		firebaseUIDFromContext(r.Context()),
		chi.URLParam(r, "profileId"),
	)
	if err != nil {
		writeError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (s Server) handleSetMainProfile(w http.ResponseWriter, r *http.Request) {
	err := s.App.Profiles.SetMain(
		r.Context(),
		firebaseUIDFromContext(r.Context()),
		chi.URLParam(r, "profileId"),
	)
	if err != nil {
		writeError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (s Server) handleUpsertChartSnapshot(w http.ResponseWriter, r *http.Request) {
	var input app.ChartSnapshotInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	item, err := s.App.Profiles.UpsertChartSnapshot(
		r.Context(),
		firebaseUIDFromContext(r.Context()),
		input,
	)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func (s Server) handleGetChartSnapshot(w http.ResponseWriter, r *http.Request) {
	year, err := strconv.Atoi(chi.URLParam(r, "year"))
	if err != nil {
		writeError(w, err)
		return
	}
	item, err := s.App.Profiles.GetChartSnapshot(
		r.Context(),
		firebaseUIDFromContext(r.Context()),
		chi.URLParam(r, "profileId"),
		year,
	)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func (s Server) handleAIChat(w http.ResponseWriter, r *http.Request) {
	var input app.AIChatInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	output, err := s.App.AI.Chat(r.Context(), firebaseUIDFromContext(r.Context()), input)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, output)
}

func (s Server) handleWallet(w http.ResponseWriter, r *http.Request) {
	wallet, err := s.App.Wallet.GetWallet(r.Context(), firebaseUIDFromContext(r.Context()))
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, wallet)
}

func (s Server) handleWalletLedger(w http.ResponseWriter, r *http.Request) {
	entries, err := s.App.Wallet.ListLedger(r.Context(), firebaseUIDFromContext(r.Context()))
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, entries)
}

func (s Server) handleWalletSpend(w http.ResponseWriter, r *http.Request) {
	var input app.WalletSpendInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	wallet, err := s.App.Wallet.Spend(r.Context(), firebaseUIDFromContext(r.Context()), input)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, wallet)
}

func (s Server) handleProducts(w http.ResponseWriter, r *http.Request) {
	if s.Products == nil {
		writeJSON(w, http.StatusOK, []config.IAPProduct{})
		return
	}
	writeJSON(w, http.StatusOK, s.Products)
}

func (s Server) handleArticles(w http.ResponseWriter, r *http.Request) {
	items, err := s.App.Articles.ListArticles(r.Context())
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, items)
}

func (s Server) handleArticleDetail(w http.ResponseWriter, r *http.Request) {
	item, err := s.App.Articles.GetArticleBySlug(r.Context(), chi.URLParam(r, "slug"))
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func (s Server) handleVerifyApple(w http.ResponseWriter, r *http.Request) {
	var input app.PurchaseVerifyInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	output, err := s.App.IAP.VerifyApple(r.Context(), firebaseUIDFromContext(r.Context()), input)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, output)
}

func (s Server) handleVerifyGoogle(w http.ResponseWriter, r *http.Request) {
	var input app.PurchaseVerifyInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		writeError(w, err)
		return
	}
	output, err := s.App.IAP.VerifyGoogle(r.Context(), firebaseUIDFromContext(r.Context()), input)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, output)
}

func (s Server) handleAppleNotifications(w http.ResponseWriter, r *http.Request) {
	var payload json.RawMessage
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		writeError(w, err)
		return
	}
	if err := s.App.IAP.HandleAppleNotification(r.Context(), payload); err != nil {
		writeError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (s Server) handleGoogleRTDN(w http.ResponseWriter, r *http.Request) {
	var payload json.RawMessage
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		writeError(w, err)
		return
	}
	if err := s.App.IAP.HandleGoogleRTDN(r.Context(), payload); err != nil {
		writeError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

type contextKey string

const firebaseUIDKey contextKey = "firebase_uid"

func debugAuthContext(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		firebaseUID := r.Header.Get("X-Debug-Firebase-Uid")
		if firebaseUID == "" {
			firebaseUID = "guest_debug_uid"
		}
		next.ServeHTTP(
			w,
			r.WithContext(context.WithValue(r.Context(), firebaseUIDKey, firebaseUID)),
		)
	})
}

func BearerAuthMiddleware(
	verify func(context.Context, string) (app.User, error),
	allowDebugBypass bool,
) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			header := strings.TrimSpace(r.Header.Get("Authorization"))
			if strings.HasPrefix(strings.ToLower(header), "bearer ") {
				token := strings.TrimSpace(header[7:])
				user, err := verify(r.Context(), token)
				if err == nil && user.FirebaseUID != "" {
					next.ServeHTTP(
						w,
						r.WithContext(
							context.WithValue(r.Context(), firebaseUIDKey, user.FirebaseUID),
						),
					)
					return
				}
			}
			if allowDebugBypass {
				debugAuthContext(next).ServeHTTP(w, r)
				return
			}
			writeError(w, errUnauthorized)
		})
	}
}

func firebaseUIDFromContext(ctx context.Context) string {
	value, _ := ctx.Value(firebaseUIDKey).(string)
	return value
}

func writeJSON(w http.ResponseWriter, statusCode int, payload any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	_ = json.NewEncoder(w).Encode(payload)
}

func writeError(w http.ResponseWriter, err error) {
	statusCode := http.StatusInternalServerError
	if errors.Is(err, errUnauthorized) || err.Error() == errUnauthorized.Error() {
		statusCode = http.StatusUnauthorized
	}
	writeJSON(w, statusCode, map[string]string{"error": err.Error()})
}

var errUnauthorized = errors.New("unauthorized")
