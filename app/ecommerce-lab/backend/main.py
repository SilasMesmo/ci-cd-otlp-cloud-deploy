import logging
import os
from pathlib import Path

# --- 1. CONFIGURAÇÃO DE TELEMETRIA (OPENTELEMETRY) ---
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

# Inicializa o provedor de traces
provider = TracerProvider()
# Envia para o coletor que está na mesma VM (localhost)
processor = BatchSpanProcessor(OTLPSpanExporter(endpoint="http://127.0.0.1:4317", insecure=True))
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)
# ----------------------------------------------------

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

# Imports do seu sistema
from backend.database.core import engine, Base, SessionLocal
from backend.models import models
from backend.routers import health, products, cart, orders

# --- 2. VIGIAR O BANCO DE DADOS ---
SQLAlchemyInstrumentor().instrument(engine=engine)

# Configura estrutura do banco
Base.metadata.create_all(bind=engine)

def seed_db():
    db = SessionLocal()
    if db.query(models.Category).count() == 0:
        cat1 = models.Category(name="Teclados Mecânicos")
        cat2 = models.Category(name="Headphones & Áudio")
        cat3 = models.Category(name="Acessórios Geek")
        db.add_all([cat1, cat2, cat3])
        db.commit()

        p1 = models.Product(
            name="Keychron K8 Pro", 
            description="Teclado mecânico wireless TKL com hot-swappable switches. Ideal para desenvolvedores.", 
            price=89.99, 
            image_url="https://images.unsplash.com/photo-1595225476474-87563907a212?q=80&w=1471&auto=format&fit=crop", 
            category_id=cat1.id
        )
        p2 = models.Product(
            name="Sony WH-1000XM5", 
            description="Headphone com o melhor cancelamento de ruído ativo do mercado para concentração profunda.", 
            price=348.00, 
            image_url="https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?q=80&w=1588&auto=format&fit=crop", 
            category_id=cat2.id
        )
        p3 = models.Product(
            name="Aeropress Clear", 
            description="A melhor forma de preparar café. Extração limpa, rápida e deliciosa.", 
            price=39.95, 
            image_url="https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=1634&auto=format&fit=crop", 
            category_id=cat3.id
        )
        p4 = models.Product(
            name="Caneca 'It works on my machine'", 
            description="Clássica caneca de café de 350ml para programadores.", 
            price=14.99, 
            image_url="https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?q=80&w=1470&auto=format&fit=crop", 
            category_id=cat3.id
        )
        
        db.add_all([p1, p2, p3, p4])
        db.commit()
    db.close()

seed_db()

# --- 3. CRIAÇÃO DO APP E INSTRUMENTAÇÃO ---
app = FastAPI(title="DevShop - Ecommerce Lab")

# Isso faz o app começar a enviar os dados de cada clique/rota
FastAPIInstrumentor.instrument_app(app)

BASE_DIR = Path(__file__).resolve().parent.parent
static_dir = BASE_DIR / "static"
templates_dir = BASE_DIR / "templates"

os.makedirs(static_dir, exist_ok=True)
os.makedirs(templates_dir, exist_ok=True)

app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")
templates = Jinja2Templates(directory=str(templates_dir))

# Incluir Rotas
app.include_router(health.router)
app.include_router(products.router)
app.include_router(products.categories_router)
app.include_router(cart.router)
app.include_router(orders.router)
app.include_router(orders.checkout_router)

def get_base_context(request: Request):
    return {
        "request": request,
        "app_version": os.getenv("APP_VERSION", "v3.0.0"),
        "environment": os.getenv("ENVIRONMENT", "local"),
    }

# --- 4. ROTAS DO SITE ---
@app.get("/")
def home(request: Request):
    return templates.TemplateResponse("index.html", get_base_context(request))

@app.get("/products")
def products_page(request: Request):
    return templates.TemplateResponse("products.html", get_base_context(request))

@app.get("/product/{product_id}")
def product_detail_page(request: Request, product_id: int):
    ctx = get_base_context(request)
    ctx["product_id"] = product_id
    return templates.TemplateResponse("product_detail.html", ctx)

@app.get("/cart")
def cart_page(request: Request):
    return templates.TemplateResponse("cart.html", get_base_context(request))

@app.get("/checkout")
def checkout_page(request: Request):
    return templates.TemplateResponse("checkout.html", get_base_context(request))

@app.get("/orders")
def orders_page(request: Request):
    return templates.TemplateResponse("orders.html", get_base_context(request))