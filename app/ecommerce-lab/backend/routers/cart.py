from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from backend.database.core import get_db
from backend.models import models
from backend.schemas import schemas

router = APIRouter(prefix="/api/cart", tags=["Cart"])

@router.get("", response_model=List[schemas.CartItem])
def get_cart(db: Session = Depends(get_db)):
    return db.query(models.CartItem).all()

@router.post("", response_model=schemas.CartItem)
def add_to_cart(item: schemas.CartItemCreate, db: Session = Depends(get_db)):
    product = db.query(models.Product).filter(models.Product.id == item.product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Check if exists
    cart_item = db.query(models.CartItem).filter(models.CartItem.product_id == item.product_id).first()
    if cart_item:
        cart_item.quantity += item.quantity
    else:
        cart_item = models.CartItem(product_id=item.product_id, quantity=item.quantity)
        db.add(cart_item)
    
    db.commit()
    db.refresh(cart_item)
    return cart_item

@router.delete("/{item_id}")
def remove_from_cart(item_id: int, db: Session = Depends(get_db)):
    cart_item = db.query(models.CartItem).filter(models.CartItem.id == item_id).first()
    if not cart_item:
        raise HTTPException(status_code=404, detail="Item not found in cart")
    db.delete(cart_item)
    db.commit()
    return {"status": "removed"}
