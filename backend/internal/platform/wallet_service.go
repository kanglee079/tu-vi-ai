package platform

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
)

type WalletService struct {
	db *pgxpool.Pool
}

func NewWalletService(db *pgxpool.Pool) *WalletService {
	return &WalletService{db: db}
}

func (s *WalletService) GetWallet(ctx context.Context, firebaseUID string) (app.WalletSnapshot, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return app.WalletSnapshot{}, err
	}

	var balance int
	err = s.db.QueryRow(ctx,
		`SELECT COALESCE(SUM(amount), 0) FROM wallet_ledger WHERE user_id = $1`,
		uid,
	).Scan(&balance)
	if err != nil {
		return app.WalletSnapshot{}, err
	}

	rows, err := s.db.Query(ctx,
		`SELECT title, amount, created_at
		 FROM wallet_ledger
		 WHERE user_id = $1
		 ORDER BY created_at DESC
		 LIMIT 50`,
		uid,
	)
	if err != nil {
		return app.WalletSnapshot{}, err
	}
	defer rows.Close()

	var history []app.WalletLedgerEntry
	for rows.Next() {
		var e app.WalletLedgerEntry
		var createdAt string
		if err := rows.Scan(&e.Title, &e.Amount, &createdAt); err != nil {
			return app.WalletSnapshot{}, err
		}
		history = append(history, e)
	}

	// Get active plan label from entitlements
	var planLabel string
	_ = s.db.QueryRow(ctx,
		`SELECT entitlement_key FROM entitlements
		 WHERE user_id = $1 AND active = true
		   AND (expires_at IS NULL OR expires_at > NOW())
		 ORDER BY created_at DESC LIMIT 1`,
		uid,
	).Scan(&planLabel)

	return app.WalletSnapshot{
		Balance:         balance,
		History:        history,
		ActivePlanLabel: planLabel,
	}, nil
}

func (s *WalletService) ListLedger(ctx context.Context, firebaseUID string) ([]app.WalletLedgerEntry, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return nil, err
	}
	rows, err := s.db.Query(ctx,
		`SELECT title, amount, TO_CHAR(created_at, 'DD/MM/YYYY')
		 FROM wallet_ledger
		 WHERE user_id = $1
		 ORDER BY created_at DESC
		 LIMIT 100`,
		uid,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var entries []app.WalletLedgerEntry
	for rows.Next() {
		var e app.WalletLedgerEntry
		if err := rows.Scan(&e.Title, &e.Amount, &e.CreatedAtLabel); err != nil {
			return nil, err
		}
		entries = append(entries, e)
	}
	return entries, rows.Err()
}

func (s *WalletService) Spend(ctx context.Context, firebaseUID string, input app.WalletSpendInput) (app.WalletSnapshot, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return app.WalletSnapshot{}, err
	}

	// Check balance
	var balance int
	err = s.db.QueryRow(ctx,
		`SELECT COALESCE(SUM(amount), 0) FROM wallet_ledger WHERE user_id = $1`,
		uid,
	).Scan(&balance)
	if err != nil {
		return app.WalletSnapshot{}, err
	}
	if balance < input.Amount {
		return app.WalletSnapshot{}, errors.New("insufficient balance")
	}

	// Insert ledger entry
	entryID := uuid.NewString()
	_, err = s.db.Exec(ctx,
		`INSERT INTO wallet_ledger (id, user_id, profile_id, entry_type, amount, reason)
		 VALUES ($1, $2, NULLIF($3, '')::uuid, 'spend', $4, $5)`,
		entryID, uid, input.ProfileID, -input.Amount, input.ContentKey,
	)
	if err != nil {
		return app.WalletSnapshot{}, err
	}

	return s.GetWallet(ctx, firebaseUID)
}

func (s *WalletService) resolveUID(ctx context.Context, firebaseUID string) (string, error) {
	if firebaseUID == "" {
		return "", ErrUnauthorized
	}
	var uid string
	err := s.db.QueryRow(ctx,
		`SELECT id FROM users WHERE firebase_uid = $1 AND deleted_at IS NULL`,
		firebaseUID,
	).Scan(&uid)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			uid = uuid.NewString()
			_, err = s.db.Exec(ctx,
				`INSERT INTO users (id, firebase_uid) VALUES ($1, $2)
				 ON CONFLICT (firebase_uid) WHERE deleted_at IS NULL DO NOTHING`,
				uid, firebaseUID,
			)
			if err != nil {
				return "", err
			}
			return uid, nil
		}
		return "", err
	}
	return uid, nil
}
