from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from backend.database.core import get_db
from backend.models import models
from backend.schemas import schemas

router = APIRouter(prefix="/api/orders", tags=["Orders"])
checkout_router = APIRouter(prefix="/api/checkout", tags=["Checkout"])

@checkout_router.post("", response_model=schemas.Order)
def checkout(order_data: schemas.OrderCreate, db: Session = Depends(get_db)):
    cart_items = db.query(models.CartItem).all()
    if not cart_items:
        raise HTTPException(status_code=400, detail="Cart is empty")
        
    total_amount = sum(item.product.price * item.quantity for item in cart_items)
    
    order = models.Order(
        customer_name=order_data.customer_name,
        customer_email=order_data.customer_email,
        total_amount=total_amount
    )
    db.add(order)
    db.commit()
    db.refresh(order)
    
    for item in cart_items:
        order_item = models.OrderItem(
            order_id=order.id,
            product_id=item.product_id,
            quantity=item.quantity,
            price_at_time=item.product.price
        )
        db.add(order_item)
        db.delete(item)  # Clear cart post-checkout
        
    db.commit()
    db.refresh(order)
    return order

@router.get("", response_model=List[schemas.Order])
def get_orders(db: Session = Depends(get_db)):
    return db.query(models.Order).order_by(models.Order.id.desc()).all()
