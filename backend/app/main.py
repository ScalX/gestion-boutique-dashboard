from fastapi import FastAPI
from app.routers import example

app = FastAPI(title='Gestion Boutique Dashboard API')

app.include_router(example.router)

@app.get('/')
def root():
    return {'message': 'API opÃ©rationnelle'}
