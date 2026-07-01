package com.hotel.model;

public class OccupancyData {
    private int period;          // month (1-12), quarter (1-4), or year
    private String label;        // "Tháng 1", "Quý 1", "2024"
    private int totalRooms;
    private int availableNights; // totalRooms * days in period
    private int occupiedNights;
    private double occupancyRate; // %
    private int bookingCount;

    public int getPeriod() { return period; }
    public void setPeriod(int period) { this.period = period; }
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int totalRooms) { this.totalRooms = totalRooms; }
    public int getAvailableNights() { return availableNights; }
    public void setAvailableNights(int availableNights) { this.availableNights = availableNights; }
    public int getOccupiedNights() { return occupiedNights; }
    public void setOccupiedNights(int occupiedNights) { this.occupiedNights = occupiedNights; }
    public double getOccupancyRate() { return occupancyRate; }
    public void setOccupancyRate(double occupancyRate) { this.occupancyRate = occupancyRate; }
    public int getBookingCount() { return bookingCount; }
    public void setBookingCount(int bookingCount) { this.bookingCount = bookingCount; }
}
