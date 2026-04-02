#criar ambiente virtual
python3 -m venv venv

#ativar ambiente virtual
source venv/bin/activate

#instalar dependencias
pip install -r requirements.txt

#execução
python3 -m uvicorn backend.main:app --reload --host 127.0.0.1 --port 8000