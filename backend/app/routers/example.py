from fastapi import APIRouter

router = APIRouter(prefix='/example', tags=['Example'])

@router.get('/')
def example_route():
    return {'status': 'ok', 'message': 'Route example fonctionnelle'}
