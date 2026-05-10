package platform

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"minh_menh_ai/backend/internal/app"
	"minh_menh_ai/backend/internal/config"
)

const openAIResponsesURL = "https://api.openai.com/v1/responses"

type OpenAIResponsesService struct {
	config     config.Config
	httpClient *http.Client
}

func NewOpenAIResponsesService(cfg config.Config) *OpenAIResponsesService {
	return &OpenAIResponsesService{
		config:     cfg,
		httpClient: &http.Client{Timeout: time.Duration(cfg.RequestTimeoutSec) * time.Second},
	}
}

func (s *OpenAIResponsesService) Chat(
	ctx context.Context,
	firebaseUID string,
	input app.AIChatInput,
) (app.AIChatOutput, error) {
	if s.config.OpenAIAPIKey == "" {
		return app.AIChatOutput{}, errors.New("OPENAI_API_KEY is not configured")
	}

	requestBody := map[string]any{
		"model": s.config.OpenAIModel,
		"instructions": strings.Join([]string{
			"Bạn là Trợ lý AI Tử Vi của app Minh Mệnh AI.",
			"Chỉ luận dựa trên dữ liệu JSON do hệ thống cung cấp.",
			"Không tự thêm sao, cung, vận, ngày, giờ hoặc sự kiện không có trong dữ liệu.",
			"Không khẳng định tuyệt đối tương lai.",
			"Luôn dùng ngôn ngữ tham khảo và nêu rõ yếu tố chứng cứ.",
			"Không tái tạo nguyên văn sách hoặc tài liệu có bản quyền.",
		}, "\n"),
		"input": []map[string]any{
			{
				"role": "developer",
				"content": []map[string]string{
					{
						"type": "input_text",
						"text": "Trả về JSON theo schema đã chỉ định. Không markdown. Không thêm trường ngoài schema.",
					},
				},
			},
			{
				"role": "user",
				"content": []map[string]string{
					{
						"type": "input_text",
						"text": fmt.Sprintf(
							"firebaseUid=%s\nscope=%s\nquestion=%s\nchartSummary=%s",
							firebaseUID,
							input.Scope,
							input.Question,
							string(input.ChartSummary),
						),
					},
				},
			},
		},
		"text": map[string]any{
			"format": map[string]any{
				"type":        "json_schema",
				"name":        "minh_menh_ai_chat_response",
				"description": "Structured tử vi answer for Minh Menh AI",
				"strict":      true,
				"schema":      aiChatSchema(),
			},
		},
	}

	payload, err := json.Marshal(requestBody)
	if err != nil {
		return app.AIChatOutput{}, err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, openAIResponsesURL, bytes.NewReader(payload))
	if err != nil {
		return app.AIChatOutput{}, err
	}
	req.Header.Set("Authorization", "Bearer "+s.config.OpenAIAPIKey)
	req.Header.Set("Content-Type", "application/json")
	resp, err := s.httpClient.Do(req)
	if err != nil {
		return app.AIChatOutput{}, err
	}
	defer resp.Body.Close()
	if resp.StatusCode >= 400 {
		return app.AIChatOutput{}, fmt.Errorf("openai responses error: %s", resp.Status)
	}

	var raw responseEnvelope
	if err := json.NewDecoder(resp.Body).Decode(&raw); err != nil {
		return app.AIChatOutput{}, err
	}
	text := raw.OutputText()
	if text == "" {
		return app.AIChatOutput{}, errors.New("openai response contained no output_text payload")
	}
	var result app.AIChatOutput
	if err := json.Unmarshal([]byte(text), &result); err != nil {
		return app.AIChatOutput{}, err
	}
	return result, nil
}

type responseEnvelope struct {
	Output []responseOutput `json:"output"`
}

func (e responseEnvelope) OutputText() string {
	var builder strings.Builder
	for _, output := range e.Output {
		for _, content := range output.Content {
			if content.Type == "output_text" {
				builder.WriteString(content.Text)
			}
		}
	}
	return builder.String()
}

type responseOutput struct {
	Content []responseContent `json:"content"`
}

type responseContent struct {
	Type string `json:"type"`
	Text string `json:"text"`
}

func aiChatSchema() map[string]any {
	return map[string]any{
		"type":                 "object",
		"additionalProperties": false,
		"required": []string{
			"title",
			"shortAnswer",
			"summaryBullets",
			"detailedReading",
			"evidence",
			"practicalAdvice",
			"avoid",
			"nextSuggestions",
			"disclaimer",
		},
		"properties": map[string]any{
			"title":            map[string]any{"type": "string"},
			"shortAnswer":      map[string]any{"type": "string"},
			"summaryBullets":   map[string]any{"type": "array", "items": map[string]any{"type": "string"}},
			"detailedReading":  map[string]any{"type": "string"},
			"practicalAdvice":  map[string]any{"type": "array", "items": map[string]any{"type": "string"}},
			"avoid":            map[string]any{"type": "array", "items": map[string]any{"type": "string"}},
			"nextSuggestions":  map[string]any{"type": "array", "items": map[string]any{"type": "string"}},
			"disclaimer":       map[string]any{"type": "string"},
			"evidence": map[string]any{
				"type": "array",
				"items": map[string]any{
					"type":                 "object",
					"additionalProperties": false,
					"required":             []string{"factor", "meaning", "impact"},
					"properties": map[string]any{
						"factor":  map[string]any{"type": "string"},
						"meaning": map[string]any{"type": "string"},
						"impact":  map[string]any{"type": "string", "enum": []string{"low", "medium", "high"}},
					},
				},
			},
		},
	}
}
