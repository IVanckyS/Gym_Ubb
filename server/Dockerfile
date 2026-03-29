# =============================================================
# Dockerfile — PRODUCCIÓN (multi-stage, imagen mínima)
# =============================================================

# Etapa 1: compilar el ejecutable
FROM dart:3.5 AS build

WORKDIR /app

# Copiar dependencias primero (mejor uso de caché de capas)
COPY pubspec.* ./
RUN dart pub get --no-precompile

# Copiar código fuente y compilar a binario nativo
COPY . .
RUN dart compile exe bin/main.dart -o bin/server

# =============================================================
# Etapa 2: imagen mínima de runtime (~5 MB)
FROM debian:bookworm-slim

# Dependencias mínimas del SO
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar solo el binario compilado
COPY --from=build /app/bin/server ./bin/server

# Usuario sin privilegios (seguridad)
RUN useradd -r -s /bin/false appuser \
    && chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

CMD ["./bin/server"]
