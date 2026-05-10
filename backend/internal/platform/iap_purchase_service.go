package platform

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
)

type IAPPurchaseService struct {
	db     *pgxpool.Pool
	config config.Config
}

func NewIAPPurchaseService(db *pgxpool.Pool, cfg config.Config) *IAPPurchaseService {
	return &IAPPurchaseService{db: db, config: cfg}
}

// RecordPurchase stores a verified purchase and grants coins/entitlements.
func (s *IAPPurchaseService) RecordPurchase(
	ctx context.Context,
	firebaseUID string,
	platform string,
	input app.PurchaseVerifyInput,
	output app.PurchaseVerifyOutput,
) error {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return err
	}

	purchaseID := uuid.NewString()
	_, err = s.db.Exec(ctx,
		`INSERT INTO iap_purchases (id, user_id, platform, product_id, transaction_id,
		 purchase_token, status, payload, created_at, updated_at)
		 VALUES ($1,$2,$3,$4,$5,$6,$7,$8,NOW(),NOW())
		 ON CONFLICT (platform, transaction_id) DO UPDATE SET updated_at = NOW()`,
		purchaseID, uid, platform, input.ProductID,
		input.TransactionID, input.PurchaseToken,
		"verified", []byte(`{}`),
	)
	if err != nil {
		return err
	}

	// Grant entitlements
	for _, ent := range output.Entitlements {
		entID := uuid.NewString()
		_, err = s.db.Exec(ctx,
			`INSERT INTO entitlements (id, user_id, entitlement_key, source, active, metadata)
			 VALUES ($1,$2,$3,$4,true,$5)`,
			entID, uid, ent, platform, []byte(`{}`),
		)
		if err != nil {
			return err
		}
	}

	// Grant coins if applicable
	if output.WalletDelta > 0 {
		ledgerID := uuid.NewString()
		_, err = s.db.Exec(ctx,
			`INSERT INTO wallet_ledger (id, user_id, entry_type, amount, reason)
			 VALUES ($1,$2,'purchase',$3,$4)`,
			ledgerID, uid, output.WalletDelta, "iap:"+input.ProductID,
		)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *IAPPurchaseService) ListPurchases(ctx context.Context, firebaseUID string) ([]map[string]any, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return nil, err
	}
	rows, err := s.db.Query(ctx,
		`SELECT id, platform, product_id, transaction_id, status, created_at
		 FROM iap_purchases WHERE user_id = $1 ORDER BY created_at DESC LIMIT 50`,
		uid,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var purchases []map[string]any
	for rows.Next() {
		var id, platform, productID, transactionID, status string
		var createdAt time.Time
		if err := rows.Scan(&id, &platform, &productID, &transactionID, &status, &createdAt); err != nil {
			return nil, err
		}
		purchases = append(purchases, map[string]any{
			"id":             id,
			"platform":       platform,
			"productId":      productID,
			"transactionId":  transactionID,
			"status":         status,
			"createdAt":      createdAt.Format(time.RFC3339),
		})
	}
	return purchases, rows.Err()
}

func (s *IAPPurchaseService) resolveUID(ctx context.Context, firebaseUID string) (string, error) {
	if firebaseUID == "" {
		return "", ErrUnauthorized
	}
	var uid string
	err := s.db.QueryRow(ctx,
		`SELECT id FROM users WHERE firebase_uid = $1 AND deleted_at IS NULL`,
		firebaseUID,
	).Scan(&uid)
	if err != nil {
		return "", err
	}
	return uid, nil
}
