package com.hotel.service;

import com.hotel.repository.DashboardRepository;
import com.hotel.model.DashboardStats;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {
    private final DashboardRepository dashboardRepository;

    public DashboardService(DashboardRepository dashboardRepository) {
        this.dashboardRepository = dashboardRepository;
    }

    public DashboardStats getStats() {
        return dashboardRepository.getStats();
    }
}
