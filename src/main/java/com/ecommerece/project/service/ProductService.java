package com.ecommerece.project.service;

import com.ecommerece.project.model.Product;
import com.ecommerece.project.payload.ProductDTO;
import com.ecommerece.project.payload.ProductResponse;

public interface ProductService {
    ProductDTO addProduct (Long categoryId, Product product);

    ProductResponse getAllProducts();
}
