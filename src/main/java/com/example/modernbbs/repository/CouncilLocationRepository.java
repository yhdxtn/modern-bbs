package com.example.modernbbs.repository;

import com.example.modernbbs.model.CouncilLocation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CouncilLocationRepository extends JpaRepository<CouncilLocation, Long> {
    List<CouncilLocation> findByScopeOrderBySortOrderAscNameAsc(String scope);
    List<CouncilLocation> findByScopeAndVisibleTrueOrderBySortOrderAscNameAsc(String scope);
    long countByScope(String scope);
    java.util.Optional<CouncilLocation> findByScopeAndName(String scope, String name);
}
