FROM python:3.11

WORKDIR /app

COPY pyproject.toml poetry.lock ./

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential

RUN --mount=type=cache,target=/root/.cache \
    pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --with main --with prod --no-root

COPY . .

RUN --mount=type=cache,target=/root/.cache \
    poetry install --no-interaction --with main --with prod

CMD [ \
    "poetry", "run", "--", \
    "gunicorn main:app --bind 0.0.0.0:8000"\
]
