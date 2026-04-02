from pydantic import BaseModel, ConfigDict
from typing import List, Optional

class ProductBase(BaseModel):
    name: str
    description: str
    price: float
    image_url: str

class Product(ProductBase):
    id: int
    category_id: int
    
    model_config = ConfigDict(from_attributes=True)

class Category(BaseModel):
    id: int
    name: str
    products: List[Product] = []

    model_config = ConfigDict(from_attributes=True)

class CartItemBase(BaseModel):
    product_id: int
    quantity: int

class CartItemCreate(CartItemBase):
    pass

class CartItemUpdate(BaseModel):
    quantity: int

class CartItem(CartItemBase):
    id: int
    product: Product

    model_config = ConfigDict(from_attributes=True)

class OrderCreate(BaseModel):
    customer_name: str
    customer_email: str

class OrderItem(BaseModel):
    id: int
    product_id: int
    quantity: int
    price_at_time: float
    product: Product

    model_config = ConfigDict(from_attributes=True)

class Order(BaseModel):
    id: int
    customer_name: str
    customer_email: str
    total_amount: float
    status: str
    items: List[OrderItem] = []

    model_config = ConfigDict(from_attributes=True)
