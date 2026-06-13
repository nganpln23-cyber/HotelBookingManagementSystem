package com.hotel.service;

import com.hotel.dao.DashboardDAO;
import com.hotel.model.DashboardStats;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {
    private final DashboardDAO dashboardDAO;

    public DashboardService(DashboardDAO dashboardDAO) {
        this.dashboardDAO = dashboardDAO;
    }

    public DashboardStats getStats() {
        return dashboardDAO.getStats();
    }
}
