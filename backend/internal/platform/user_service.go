package platform

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
)

type UserService struct {
	db *pgxpool.Pool
}

func NewUserService(db *pgxpool.Pool) *UserService {
	return &UserService{db: db}
}

func (s *UserService) GetMe(ctx context.Context, firebaseUID string) (app.User, error) {
	if firebaseUID == "" {
		return app.User{}, ErrUnauthorized
	}
	var user app.User
	err := s.db.QueryRow(ctx,
		`SELECT id, firebase_uid, email, display_name FROM users
		 WHERE firebase_uid = $1 AND deleted_at IS NULL`,
		firebaseUID,
	).Scan(&user.ID, &user.FirebaseUID, &user.Email, &user.DisplayName)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			// Auto-create user on first login (upsert-like behavior)
			id := uuid.NewString()
			_, err := s.db.Exec(ctx,
				`INSERT INTO users (id, firebase_uid) VALUES ($1, $2)
				 ON CONFLICT (firebase_uid) WHERE deleted_at IS NULL DO NOTHING`,
				id, firebaseUID,
			)
			if err != nil {
				return app.User{}, err
			}
			return app.User{ID: id, FirebaseUID: firebaseUID}, nil
		}
		return app.User{}, err
	}
	return user, nil
}

func (s *UserService) DeleteMe(ctx context.Context, firebaseUID string) error {
	if firebaseUID == "" {
		return ErrUnauthorized
	}
	_, err := s.db.Exec(ctx,
		`UPDATE users SET deleted_at = $1 WHERE firebase_uid = $2 AND deleted_at IS NULL`,
		time.Now(), firebaseUID,
	)
	return err
}
