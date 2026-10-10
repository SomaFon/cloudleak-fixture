# Static scanning fixture only. No executable, no service, no real credentials.
FROM scratch
LABEL org.opencontainers.image.title="CloudLeak authorized synthetic fixture"
LABEL org.opencontainers.image.description="Synthetic data only; not a runnable application"
COPY config/demo.env /fixtures/demo.env
COPY config/clean.env /fixtures/clean.env
