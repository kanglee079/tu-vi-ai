package platform

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
)

type IdempotencyService struct {
	db *pgxpool.Pool
}

func NewIdempotencyService(db *pgxpool.Pool) *IdempotencyService {
	return &IdempotencyService{db: db}
}

func (s *IdempotencyService) Load(ctx context.Context, key string) (app.IdempotencyResult, bool, error) {
	var responseCode int
	var responseBody []byte
	err := s.db.QueryRow(ctx,
		`SELECT response_code, response_body FROM idempotency_keys WHERE key = $1`,
		key,
	).Scan(&responseCode, &responseBody)
	if err != nil {
		return app.IdempotencyResult{}, false, nil
	}
	return app.IdempotencyResult{
		StatusCode: responseCode,
		Body:       responseBody,
	}, true, nil
}

func (s *IdempotencyService) Store(ctx context.Context, key string, result app.IdempotencyResult) error {
	_, err := s.db.Exec(ctx,
		`INSERT INTO idempotency_keys (key, scope, response_code, response_body, created_at)
		 VALUES ($1, 'general', $2, $3, $4)
		 ON CONFLICT (key) DO UPDATE SET
		   response_code = EXCLUDED.response_code,
		   response_body = EXCLUDED.response_body`,
		key, result.StatusCode, result.Body, time.Now(),
	)
	return err
}
