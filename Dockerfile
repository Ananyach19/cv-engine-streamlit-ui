FROM Python:3.11

WORKDIR /app

COPY pyproject.toml poetry.lock ./

RUN pip install poetry && poetry install

COPY . .

CMD ["poetry", "run", "streamlit", "run", "app.py"]
