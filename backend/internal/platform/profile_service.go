package platform

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
)

type ProfileService struct {
	db *pgxpool.Pool
}

func NewProfileService(db *pgxpool.Pool) *ProfileService {
	return &ProfileService{db: db}
}

func (s *ProfileService) ListProfiles(ctx context.Context, firebaseUID string) ([]app.Profile, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return nil, err
	}
	rows, err := s.db.Query(ctx,
		`SELECT id, name, gender, calendar_type, birth_date, birth_hour_label,
		        birth_minute, birth_place, timezone, birth_time_confidence,
		        main_focus, is_main
		 FROM profiles WHERE user_id = $1 ORDER BY is_main DESC, created_at ASC`,
		uid,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var profiles []app.Profile
	for rows.Next() {
		var p app.Profile
		var mainFocus []byte
		err := rows.Scan(
			&p.ID, &p.Name, &p.Gender, &p.CalendarType, &p.BirthDate,
			&p.BirthHourLabel, &p.BirthMinute, &p.BirthPlace, &p.Timezone,
			&p.BirthTimeConfidence, &mainFocus, &p.IsMain,
		)
		if err != nil {
			return nil, err
		}
		p.MainFocus = json.RawMessage(mainFocus)
		profiles = append(profiles, p)
	}
	return profiles, rows.Err()
}

func (s *ProfileService) CreateProfile(ctx context.Context, firebaseUID string, input app.CreateProfileInput) (app.Profile, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return app.Profile{}, err
	}

	// If this is the first profile, make it main
	var count int
	_ = s.db.QueryRow(ctx, `SELECT COUNT(*) FROM profiles WHERE user_id = $1`, uid).Scan(&count)
	if count == 0 {
		input.IsMain = true
	}

	mainFocus, _ := json.Marshal(input.MainFocus)
	id := uuid.NewString()
	_, err = s.db.Exec(ctx,
		`INSERT INTO profiles (id, user_id, name, gender, calendar_type, birth_date,
		 birth_hour_label, birth_minute, birth_place, timezone, birth_time_confidence,
		 main_focus, is_main)
		 VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)`,
		id, uid, input.Name, input.Gender, input.CalendarType, input.BirthDate,
		input.BirthHourLabel, input.BirthMinute, input.BirthPlace, input.Timezone,
		input.BirthTimeConfidence, mainFocus, input.IsMain,
	)
	if err != nil {
		return app.Profile{}, err
	}
	input.ID = id
	input.IsMain = count == 0
	return input, nil
}

func (s *ProfileService) UpdateProfile(ctx context.Context, firebaseUID, profileID string, input app.CreateProfileInput) (app.Profile, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return app.Profile{}, err
	}
	mainFocus, _ := json.Marshal(input.MainFocus)
	_, err = s.db.Exec(ctx,
		`UPDATE profiles SET name=$1, gender=$2, calendar_type=$3, birth_date=$4,
		 birth_hour_label=$5, birth_minute=$6, birth_place=$7, timezone=$8,
		 birth_time_confidence=$9, main_focus=$10, updated_at=NOW()
		 WHERE id=$11 AND user_id=$12`,
		input.Name, input.Gender, input.CalendarType, input.BirthDate,
		input.BirthHourLabel, input.BirthMinute, input.BirthPlace, input.Timezone,
		input.BirthTimeConfidence, mainFocus, profileID, uid,
	)
	if err != nil {
		return app.Profile{}, err
	}
	input.ID = profileID
	return input, nil
}

func (s *ProfileService) DeleteProfile(ctx context.Context, firebaseUID, profileID string) error {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return err
	}
	result, err := s.db.Exec(ctx,
		`DELETE FROM profiles WHERE id=$1 AND user_id=$2`, profileID, uid,
	)
	if err != nil {
		return err
	}
	if result.RowsAffected() == 0 {
		return errors.New("profile not found")
	}
	return nil
}

func (s *ProfileService) SetMain(ctx context.Context, firebaseUID, profileID string) error {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return err
	}
	tx, err := s.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	_, err = tx.Exec(ctx,
		`UPDATE profiles SET is_main = false WHERE user_id = $1`, uid,
	)
	if err != nil {
		return err
	}
	result, err := tx.Exec(ctx,
		`UPDATE profiles SET is_main = true WHERE id = $1 AND user_id = $2`, profileID, uid,
	)
	if err != nil {
		return err
	}
	if result.RowsAffected() == 0 {
		return errors.New("profile not found")
	}
	return tx.Commit(ctx)
}

func (s *ProfileService) UpsertChartSnapshot(ctx context.Context, firebaseUID string, input app.ChartSnapshotInput) (app.ChartSnapshot, error) {
	uid, err := s.resolveUID(ctx, firebaseUID)
	if err != nil {
		return app.ChartSnapshot{}, err
	}

	// Resolve profile_id to user_id check
	var profileUserID string
	err = s.db.QueryRow(ctx,
		`SELECT user_id FROM profiles WHERE id = $1`, input.ProfileID,
	).Scan(&profileUserID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return app.ChartSnapshot{}, errors.New("profile not found")
		}
		return app.ChartSnapshot{}, err
	}
	if profileUserID != uid {
		return app.ChartSnapshot{}, ErrUnauthorized
	}

	// Upsert: insert or update on conflict
	id := uuid.NewString()
	_, err = s.db.Exec(ctx,
		`INSERT INTO chart_snapshots (id, user_id, profile_id, year, engine_version,
		 schema_version, snapshot_hash, payload)
		 VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
		 ON CONFLICT (profile_id, year, snapshot_hash)
		 DO UPDATE SET payload = EXCLUDED.payload, updated_at = NOW()
		 RETURNING id`,
		id, uid, input.ProfileID, input.Year, input.EngineVersion,
		input.SchemaVersion, input.SnapshotHash, input.Payload,
	)
	if err != nil {
		return app.ChartSnapshot{}, err
	}
	return app.ChartSnapshot{
		ID:            id,
		ProfileID:     input.ProfileID,
		Year:          input.Year,
		EngineVersion: input.EngineVersion,
		SchemaVersion: input.SchemaVersion,
		SnapshotHash:  input.SnapshotHash,
		Payload:       input.Payload,
	}, nil
}

func (s *ProfileService) GetChartSnapshot(ctx context.Context, firebaseUID, profileID string, year int) (app.ChartSnapshot, error) {
	if _, err := s.resolveUID(ctx, firebaseUID); err != nil {
		return app.ChartSnapshot{}, err
	}
	var snap app.ChartSnapshot
	err := s.db.QueryRow(ctx,
		`SELECT id, profile_id, year, engine_version, schema_version,
		        snapshot_hash, payload
		 FROM chart_snapshots
		 WHERE profile_id = $1 AND year = $2
		 ORDER BY updated_at DESC LIMIT 1`,
		profileID, year,
	).Scan(&snap.ID, &snap.ProfileID, &snap.Year, &snap.EngineVersion,
		&snap.SchemaVersion, &snap.SnapshotHash, &snap.Payload)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return app.ChartSnapshot{}, errors.New("chart snapshot not found")
		}
		return app.ChartSnapshot{}, err
	}
	return snap, nil
}

func (s *ProfileService) resolveUID(ctx context.Context, firebaseUID string) (string, error) {
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
			// Auto-create if missing
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
