package com.hotel.model;

import java.math.BigDecimal;
import java.util.List;

public class DashboardStats {
    private int totalRooms;
    private int availableRooms;
    private int occupiedRooms;
    private int bookedRooms;
    private int maintenanceRooms;
    private int totalCustomers;
    private int totalBookings;
    private int pendingBookings;
    private int checkedInCount;
    private BigDecimal totalRevenue;
    private List<Booking> recentBookings;

    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int v) { this.totalRooms = v; }
    public int getAvailableRooms() { return availableRooms; }
    public void setAvailableRooms(int v) { this.availableRooms = v; }
    public int getOccupiedRooms() { return occupiedRooms; }
    public void setOccupiedRooms(int v) { this.occupiedRooms = v; }
    public int getBookedRooms() { return bookedRooms; }
    public void setBookedRooms(int v) { this.bookedRooms = v; }
    public int getMaintenanceRooms() { return maintenanceRooms; }
    public void setMaintenanceRooms(int v) { this.maintenanceRooms = v; }
    public int getTotalCustomers() { return totalCustomers; }
    public void setTotalCustomers(int v) { this.totalCustomers = v; }
    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int v) { this.totalBookings = v; }
    public int getPendingBookings() { return pendingBookings; }
    public void setPendingBookings(int v) { this.pendingBookings = v; }
    public int getCheckedInCount() { return checkedInCount; }
    public void setCheckedInCount(int v) { this.checkedInCount = v; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal v) { this.totalRevenue = v; }
    public List<Booking> getRecentBookings() { return recentBookings; }
    public void setRecentBookings(List<Booking> v) { this.recentBookings = v; }

    public double getOccupancyRate() {
        if (totalRooms == 0) return 0.0;
        return Math.round((double)(occupiedRooms + bookedRooms) / totalRooms * 1000.0) / 10.0;
    }
}
