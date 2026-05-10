package platform

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"

	"minh_menh_ai/backend/internal/app"
)

type ArticleService struct {
	db *pgxpool.Pool
}

func NewArticleService(db *pgxpool.Pool) *ArticleService {
	return &ArticleService{db: db}
}

func (s *ArticleService) ListArticles(ctx context.Context) ([]app.Article, error) {
	rows, err := s.db.Query(ctx,
		`SELECT id, slug, category, title, summary, body
		 FROM knowledge_articles
		 WHERE published = true
		 ORDER BY created_at DESC
		 LIMIT 50`,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var articles []app.Article
	for rows.Next() {
		var a app.Article
		if err := rows.Scan(&a.ID, &a.Slug, &a.Category, &a.Title, &a.Summary, &a.Body); err != nil {
			return nil, err
		}
		articles = append(articles, a)
	}
	return articles, rows.Err()
}

func (s *ArticleService) GetArticleBySlug(ctx context.Context, slug string) (app.Article, error) {
	var a app.Article
	err := s.db.QueryRow(ctx,
		`SELECT id, slug, category, title, summary, body
		 FROM knowledge_articles
		 WHERE slug = $1 AND published = true`,
		slug,
	).Scan(&a.ID, &a.Slug, &a.Category, &a.Title, &a.Summary, &a.Body)
	if err != nil {
		return app.Article{}, err
	}
	return a, nil
}
