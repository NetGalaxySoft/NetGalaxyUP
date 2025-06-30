from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    API_VERSION: str = "0.1.0"
    # DATABASE_URL: str  # добави го по-късно, когато свържеш БД

    # Pydantic 2 конфигурация
    model_config = SettingsConfigDict(env_file=".env")

settings = Settings()
