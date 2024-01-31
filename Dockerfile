FROM python:3.11

WORKDIR /app

COPY pyproject.toml poetry.lock ./

RUN pip install poetry && poetry install

COPY . .

ENTRYPOINT ["poetry", "run", "streamlit", "run", "cv-engine-ui.py", "--server.port=8000", "--server.address=0.0.0.0"]
