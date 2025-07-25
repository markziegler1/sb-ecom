package com.ecommerece.project.repositories;

import com.ecommerece.project.model.AppRole;
import com.ecommerece.project.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByRoleName(AppRole appRole);
}
