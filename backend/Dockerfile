FROM golang:1.22 AS build

WORKDIR /src
COPY go.mod ./
COPY cmd ./cmd
COPY internal ./internal

RUN go build -o /out/api ./cmd/api

FROM gcr.io/distroless/base-debian12

WORKDIR /app
COPY --from=build /out/api /app/api

EXPOSE 8080
ENTRYPOINT ["/app/api"]
