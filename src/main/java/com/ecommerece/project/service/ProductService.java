package com.ecommerece.project.service;

import com.ecommerece.project.model.Product;
import com.ecommerece.project.payload.ProductDTO;
import com.ecommerece.project.payload.ProductResponse;

public interface ProductService {
    ProductDTO addProduct (Long categoryId, ProductDTO productDTO);

    ProductResponse getAllProducts();

    ProductResponse searchByCategory(Long categoryId);

    ProductResponse searchProductByKeyword(String keyword);

    ProductDTO updateProduct(Long productId, ProductDTO productDTO);

    ProductDTO deleteProduct(Long productId);
}
