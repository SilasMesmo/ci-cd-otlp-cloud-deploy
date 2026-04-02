from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Implements a local SQLite file database to avoid threading limitations 
# of purely in-memory databases with FastAPI/Uvicorn.
SQLALCHEMY_DATABASE_URL = "sqlite:///./ecommerce.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
