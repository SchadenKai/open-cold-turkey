# Use the official Python image as the base image
FROM python:3.13-slim-bookworm

# Install uv for faster package management
COPY --from=ghcr.io/astral-sh/uv:0.7.21 /uv /bin/uv

# Set the working directory
WORKDIR /app

# Copy the requirements.txt file
COPY ./pyproject.toml /app/pyproject.toml

ENV VIRTUAL_ENV=/app/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies
ENV UV_HTTP_TIMEOUT=300
# Use BuildKit cache mount to persist pip/uv cache
RUN --mount=type=cache,target=/root/.cache \
    uv sync --no-dev && \
    uv pip uninstall py

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 8000

# Start the application
CMD ["fastapi", "dev", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]