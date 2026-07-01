package com.hotel.service;

import com.hotel.model.*;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@Service
public class ExportService {

    private static final NumberFormat VND = NumberFormat.getNumberInstance(new Locale("vi", "VN"));

    // ─── EXCEL EXPORTS ───────────────────────────────────────────────────────

    public byte[] exportRevenueDaily(RevenueReport report) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Doanh thu theo ngay");
            CellStyle header = headerStyle(wb);
            CellStyle money = moneyStyle(wb);
            CellStyle normal = normalStyle(wb);

            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("BAO CAO DOANH THU THEO NGAY");
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 2));

            Row sub = sheet.createRow(row++);
            sub.createCell(0).setCellValue("Tu: " + report.getFrom() + "  Den: " + report.getTo());
            sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 2));
            row++;

            Row sumRow = sheet.createRow(row++);
            createCell(sumRow, 0, "Tong doanh thu:", header);
            createCell(sumRow, 1, report.getTotalRevenue().doubleValue(), money);
            Row cntRow = sheet.createRow(row++);
            createCell(cntRow, 0, "So giao dich:", header);
            createCell(cntRow, 1, (double) report.getPaymentCount(), normal);
            row++;

            Row hdr = sheet.createRow(row++);
            createCell(hdr, 0, "Ngay", header);
            createCell(hdr, 1, "Giao dich", header);
            createCell(hdr, 2, "Doanh thu (VND)", header);

            for (DailyRevenue d : report.getDailyRevenue()) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, d.getDate().toString(), normal);
                createCell(r, 1, (double) d.getPaymentCount(), normal);
                createCell(r, 2, d.getTotalAmount().doubleValue(), money);
            }

            if (!report.getRoomTypeRevenue().isEmpty()) {
                row++;
                Row rth = sheet.createRow(row++);
                createCell(rth, 0, "Loai phong", header);
                createCell(rth, 1, "So booking", header);
                createCell(rth, 2, "Doanh thu (VND)", header);
                for (RoomTypeRevenue rt : report.getRoomTypeRevenue()) {
                    Row r = sheet.createRow(row++);
                    createCell(r, 0, rt.getTypeName(), normal);
                    createCell(r, 1, (double) rt.getBookingCount(), normal);
                    createCell(r, 2, rt.getTotalAmount().doubleValue(), money);
                }
            }

            autoSize(sheet, 3);
            return toBytes(wb);
        }
    }

    public byte[] exportRevenueMonthly(List<MonthlyRevenue> data, int year) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Doanh thu theo thang");
            CellStyle header = headerStyle(wb);
            CellStyle money = moneyStyle(wb);
            CellStyle normal = normalStyle(wb);

            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("BAO CAO DOANH THU THEO THANG - NAM " + year);
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 2));
            row++;

            Row hdr = sheet.createRow(row++);
            createCell(hdr, 0, "Thang", header);
            createCell(hdr, 1, "Giao dich", header);
            createCell(hdr, 2, "Doanh thu (VND)", header);

            for (MonthlyRevenue m : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, "Thang " + m.getMonth() + "/" + m.getYear(), normal);
                createCell(r, 1, (double) m.getPaymentCount(), normal);
                createCell(r, 2, m.getTotalAmount().doubleValue(), money);
            }

            autoSize(sheet, 3);
            return toBytes(wb);
        }
    }

    public byte[] exportRevenueQuarterly(List<QuarterlyRevenue> data, int year) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Doanh thu theo quy");
            CellStyle header = headerStyle(wb);
            CellStyle money = moneyStyle(wb);
            CellStyle normal = normalStyle(wb);

            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("BAO CAO DOANH THU THEO QUY - NAM " + year);
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));
            row++;

            Row hdr = sheet.createRow(row++);
            createCell(hdr, 0, "Quy", header);
            createCell(hdr, 1, "Giao dich", header);
            createCell(hdr, 2, "Doanh thu (VND)", header);
            createCell(hdr, 3, "Ty le", header);

            double total = data.stream().mapToDouble(q -> q.getTotalAmount().doubleValue()).sum();
            for (QuarterlyRevenue q : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, "Q" + q.getQuarter() + "/" + q.getYear(), normal);
                createCell(r, 1, (double) q.getPaymentCount(), normal);
                createCell(r, 2, q.getTotalAmount().doubleValue(), money);
                double pct = total > 0 ? q.getTotalAmount().doubleValue() / total * 100 : 0;
                createCell(r, 3, String.format("%.1f%%", pct), normal);
            }

            autoSize(sheet, 4);
            return toBytes(wb);
        }
    }

    public byte[] exportRevenueYearly(List<YearlyRevenue> data) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Doanh thu theo nam");
            CellStyle header = headerStyle(wb);
            CellStyle money = moneyStyle(wb);
            CellStyle normal = normalStyle(wb);

            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("BAO CAO DOANH THU THEO NAM");
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 2));
            row++;

            Row hdr = sheet.createRow(row++);
            createCell(hdr, 0, "Nam", header);
            createCell(hdr, 1, "Giao dich", header);
            createCell(hdr, 2, "Doanh thu (VND)", header);

            for (YearlyRevenue y : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, String.valueOf(y.getYear()), normal);
                createCell(r, 1, (double) y.getPaymentCount(), normal);
                createCell(r, 2, y.getTotalAmount().doubleValue(), money);
            }

            autoSize(sheet, 3);
            return toBytes(wb);
        }
    }

    public byte[] exportTopCustomers(List<TopCustomer> data) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Top khach hang");
            CellStyle header = headerStyle(wb);
            CellStyle money = moneyStyle(wb);
            CellStyle normal = normalStyle(wb);

            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("BAO CAO TOP KHACH HANG");
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 6));
            row++;

            Row hdr = sheet.createRow(row++);
            createCell(hdr, 0, "#", header);
            createCell(hdr, 1, "Ho ten", header);
            createCell(hdr, 2, "So dien thoai", header);
            createCell(hdr, 3, "Email", header);
            createCell(hdr, 4, "So lan dat", header);
            createCell(hdr, 5, "Tong chi tieu (VND)", header);
            createCell(hdr, 6, "Lan dat gan nhat", header);

            int idx = 1;
            for (TopCustomer tc2 : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, String.valueOf(idx++), normal);
                createCell(r, 1, tc2.getFullName(), normal);
                createCell(r, 2, tc2.getPhone(), normal);
                createCell(r, 3, tc2.getEmail() != null ? tc2.getEmail() : "", normal);
                createCell(r, 4, (double) tc2.getBookingCount(), normal);
                createCell(r, 5, tc2.getTotalSpent().doubleValue(), money);
                createCell(r, 6, tc2.getLastBookingDate() != null ? tc2.getLastBookingDate() : "", normal);
            }

            autoSize(sheet, 7);
            return toBytes(wb);
        }
    }

    // ─── PDF EXPORTS ─────────────────────────────────────────────────────────

    public byte[] exportRevenueDailyPdf(RevenueReport report) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4.rotate(), 30, 30, 40, 30);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font subFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
        Font hdrFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

        doc.add(new Paragraph("BAO CAO DOANH THU THEO NGAY", titleFont));
        doc.add(new Paragraph("Tu: " + report.getFrom() + "   Den: " + report.getTo(), subFont));
        doc.add(new Paragraph("Tong doanh thu: " + VND.format(report.getTotalRevenue()) + "d   |   So giao dich: " + report.getPaymentCount(), subFont));
        doc.add(Chunk.NEWLINE);

        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{3f, 1.5f, 2.5f});
        addPdfHeader(table, hdrFont, "Ngay", "Giao dich", "Doanh thu (VND)");
        for (DailyRevenue d : report.getDailyRevenue()) {
            addPdfRow(table, cellFont, false,
                    d.getDate().toString(),
                    String.valueOf(d.getPaymentCount()),
                    VND.format(d.getTotalAmount()) + "d");
        }
        doc.add(table);

        if (!report.getRoomTypeRevenue().isEmpty()) {
            doc.add(Chunk.NEWLINE);
            doc.add(new Paragraph("Theo loai phong:", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11)));
            PdfPTable rt = new PdfPTable(3);
            rt.setWidthPercentage(100);
            rt.setWidths(new float[]{3f, 1.5f, 2.5f});
            addPdfHeader(rt, hdrFont, "Loai phong", "So booking", "Doanh thu (VND)");
            for (RoomTypeRevenue r : report.getRoomTypeRevenue()) {
                addPdfRow(rt, cellFont, false,
                        r.getTypeName(),
                        String.valueOf(r.getBookingCount()),
                        VND.format(r.getTotalAmount()) + "d");
            }
            doc.add(rt);
        }

        doc.close();
        return out.toByteArray();
    }

    public byte[] exportRevenueMonthlyPdf(List<MonthlyRevenue> data, int year) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4, 40, 40, 50, 40);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font hdrFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

        doc.add(new Paragraph("BAO CAO DOANH THU THEO THANG - NAM " + year, titleFont));
        doc.add(Chunk.NEWLINE);

        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        addPdfHeader(table, hdrFont, "Thang", "Giao dich", "Doanh thu (VND)");
        for (MonthlyRevenue m : data) {
            addPdfRow(table, cellFont, false,
                    "Thang " + m.getMonth() + "/" + m.getYear(),
                    String.valueOf(m.getPaymentCount()),
                    VND.format(m.getTotalAmount()) + "d");
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    public byte[] exportRevenueQuarterlyPdf(List<QuarterlyRevenue> data, int year) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4, 40, 40, 50, 40);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font hdrFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

        doc.add(new Paragraph("BAO CAO DOANH THU THEO QUY - NAM " + year, titleFont));
        doc.add(Chunk.NEWLINE);

        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        addPdfHeader(table, hdrFont, "Quy", "Giao dich", "Doanh thu (VND)", "Ty le");
        double total = data.stream().mapToDouble(q -> q.getTotalAmount().doubleValue()).sum();
        for (QuarterlyRevenue q : data) {
            double pct = total > 0 ? q.getTotalAmount().doubleValue() / total * 100 : 0;
            addPdfRow(table, cellFont, false,
                    "Q" + q.getQuarter() + "/" + q.getYear(),
                    String.valueOf(q.getPaymentCount()),
                    VND.format(q.getTotalAmount()) + "d",
                    String.format("%.1f%%", pct));
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    public byte[] exportRevenueYearlyPdf(List<YearlyRevenue> data) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4, 40, 40, 50, 40);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font hdrFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

        doc.add(new Paragraph("BAO CAO DOANH THU THEO NAM", titleFont));
        doc.add(Chunk.NEWLINE);

        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        addPdfHeader(table, hdrFont, "Nam", "Giao dich", "Doanh thu (VND)");
        for (YearlyRevenue y : data) {
            addPdfRow(table, cellFont, false,
                    String.valueOf(y.getYear()),
                    String.valueOf(y.getPaymentCount()),
                    VND.format(y.getTotalAmount()) + "d");
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    public byte[] exportTopCustomersPdf(List<TopCustomer> data) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4.rotate(), 30, 30, 40, 30);
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font hdrFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

        doc.add(new Paragraph("BAO CAO TOP KHACH HANG", titleFont));
        doc.add(Chunk.NEWLINE);

        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{0.5f, 2.5f, 1.5f, 2.5f, 1f, 2f, 1.8f});
        addPdfHeader(table, hdrFont, "#", "Ho ten", "SDT", "Email", "So lan dat", "Tong chi tieu", "Lan dat cuoi");
        int idx = 1;
        for (TopCustomer tc : data) {
            addPdfRow(table, cellFont, idx % 2 == 0,
                    String.valueOf(idx++),
                    tc.getFullName(),
                    tc.getPhone(),
                    tc.getEmail() != null ? tc.getEmail() : "",
                    String.valueOf(tc.getBookingCount()),
                    VND.format(tc.getTotalSpent()) + "d",
                    tc.getLastBookingDate() != null ? tc.getLastBookingDate() : "");
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    // ─── OCCUPANCY EXPORTS ───────────────────────────────────────────────────

    public byte[] exportOccupancyMonthly(List<OccupancyData> data, int year) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Lap day thang " + year);
            CellStyle hdr = headerStyle(wb);
            CellStyle num = normalStyle(wb);
            CellStyle pct = normalStyle(wb);

            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("TY LE LAP DAY PHONG THEO THANG NAM " + year);
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
            row++;

            Row hdrRow = sheet.createRow(row++);
            createCell(hdrRow, 0, "Thang", hdr);
            createCell(hdrRow, 1, "Tong phong", hdr);
            createCell(hdrRow, 2, "Dem phong co san", hdr);
            createCell(hdrRow, 3, "Dem phong da dat", hdr);
            createCell(hdrRow, 4, "So booking", hdr);
            createCell(hdrRow, 5, "Ty le lap day (%)", hdr);

            for (OccupancyData d : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, d.getLabel(), num);
                createCell(r, 1, d.getTotalRooms(), num);
                createCell(r, 2, d.getAvailableNights(), num);
                createCell(r, 3, d.getOccupiedNights(), num);
                createCell(r, 4, d.getBookingCount(), num);
                createCell(r, 5, Math.round(d.getOccupancyRate() * 10.0) / 10.0, pct);
            }
            autoSize(sheet, 6);
            return toBytes(wb);
        }
    }

    public byte[] exportOccupancyQuarterly(List<OccupancyData> data, int year) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Lap day quy " + year);
            CellStyle hdr = headerStyle(wb);
            CellStyle num = normalStyle(wb);
            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("TY LE LAP DAY PHONG THEO QUY NAM " + year);
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
            row++;
            Row hdrRow = sheet.createRow(row++);
            createCell(hdrRow, 0, "Quy", hdr);
            createCell(hdrRow, 1, "Tong phong", hdr);
            createCell(hdrRow, 2, "Dem phong co san", hdr);
            createCell(hdrRow, 3, "Dem phong da dat", hdr);
            createCell(hdrRow, 4, "So booking", hdr);
            createCell(hdrRow, 5, "Ty le lap day (%)", hdr);
            for (OccupancyData d : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, d.getLabel(), num);
                createCell(r, 1, d.getTotalRooms(), num);
                createCell(r, 2, d.getAvailableNights(), num);
                createCell(r, 3, d.getOccupiedNights(), num);
                createCell(r, 4, d.getBookingCount(), num);
                createCell(r, 5, Math.round(d.getOccupancyRate() * 10.0) / 10.0, num);
            }
            autoSize(sheet, 6);
            return toBytes(wb);
        }
    }

    public byte[] exportOccupancyYearly(List<OccupancyData> data) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Lap day theo nam");
            CellStyle hdr = headerStyle(wb);
            CellStyle num = normalStyle(wb);
            int row = 0;
            Row title = sheet.createRow(row++);
            Cell tc = title.createCell(0);
            tc.setCellValue("TY LE LAP DAY PHONG THEO NAM");
            tc.setCellStyle(titleStyle(wb));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
            row++;
            Row hdrRow = sheet.createRow(row++);
            createCell(hdrRow, 0, "Nam", hdr);
            createCell(hdrRow, 1, "Tong phong", hdr);
            createCell(hdrRow, 2, "Dem phong co san", hdr);
            createCell(hdrRow, 3, "Dem phong da dat", hdr);
            createCell(hdrRow, 4, "So booking", hdr);
            createCell(hdrRow, 5, "Ty le lap day (%)", hdr);
            for (OccupancyData d : data) {
                Row r = sheet.createRow(row++);
                createCell(r, 0, d.getLabel(), num);
                createCell(r, 1, d.getTotalRooms(), num);
                createCell(r, 2, d.getAvailableNights(), num);
                createCell(r, 3, d.getOccupiedNights(), num);
                createCell(r, 4, d.getBookingCount(), num);
                createCell(r, 5, Math.round(d.getOccupancyRate() * 10.0) / 10.0, num);
            }
            autoSize(sheet, 6);
            return toBytes(wb);
        }
    }

    public byte[] exportOccupancyMonthlyPdf(List<OccupancyData> data, int year) throws IOException {
        return exportOccupancyPdf(data, "TY LE LAP DAY PHONG THEO THANG NAM " + year);
    }

    public byte[] exportOccupancyQuarterlyPdf(List<OccupancyData> data, int year) throws IOException {
        return exportOccupancyPdf(data, "TY LE LAP DAY PHONG THEO QUY NAM " + year);
    }

    public byte[] exportOccupancyYearlyPdf(List<OccupancyData> data) throws IOException {
        return exportOccupancyPdf(data, "TY LE LAP DAY PHONG THEO NAM");
    }

    private byte[] exportOccupancyPdf(List<OccupancyData> data, String titleText) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4.rotate());
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
        Font hdrFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
        Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

        Paragraph title = new Paragraph(titleText, titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(12);
        doc.add(title);

        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{2f, 1.5f, 2f, 2f, 1.5f, 2f});
        addPdfHeader(table, hdrFont, "Ky", "Tong phong", "Dem co san", "Dem da dat", "Booking", "Ty le (%)");

        boolean shade = false;
        for (OccupancyData d : data) {
            addPdfRow(table, cellFont, shade,
                d.getLabel(),
                String.valueOf(d.getTotalRooms()),
                String.valueOf(d.getAvailableNights()),
                String.valueOf(d.getOccupiedNights()),
                String.valueOf(d.getBookingCount()),
                String.format("%.1f%%", d.getOccupancyRate()));
            shade = !shade;
        }
        doc.add(table);
        doc.close();
        return out.toByteArray();
    }

    // ─── HELPERS ─────────────────────────────────────────────────────────────

    private void addPdfHeader(PdfPTable table, Font font, String... cols) {
        for (String col : cols) {
            PdfPCell cell = new PdfPCell(new Phrase(col, font));
            cell.setBackgroundColor(new Color(79, 70, 229));
            cell.setPadding(6);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
    }

    private void addPdfRow(PdfPTable table, Font font, boolean shaded, String... vals) {
        Color bg = shaded ? new Color(237, 233, 254) : Color.WHITE;
        for (String val : vals) {
            PdfPCell cell = new PdfPCell(new Phrase(val, font));
            cell.setBackgroundColor(bg);
            cell.setPadding(5);
            table.addCell(cell);
        }
    }

    private CellStyle titleStyle(XSSFWorkbook wb) {
        CellStyle s = wb.createCellStyle();
        org.apache.poi.ss.usermodel.Font f = wb.createFont();
        f.setBold(true);
        f.setFontHeightInPoints((short) 14);
        s.setFont(f);
        return s;
    }

    private CellStyle headerStyle(XSSFWorkbook wb) {
        CellStyle s = wb.createCellStyle();
        s.setFillForegroundColor(IndexedColors.INDIGO.getIndex());
        s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        org.apache.poi.ss.usermodel.Font f = wb.createFont();
        f.setBold(true);
        f.setColor(IndexedColors.WHITE.getIndex());
        s.setFont(f);
        s.setBorderBottom(BorderStyle.THIN);
        s.setBorderTop(BorderStyle.THIN);
        s.setBorderLeft(BorderStyle.THIN);
        s.setBorderRight(BorderStyle.THIN);
        return s;
    }

    private CellStyle moneyStyle(XSSFWorkbook wb) {
        CellStyle s = normalStyle(wb);
        DataFormat fmt = wb.createDataFormat();
        s.setDataFormat(fmt.getFormat("#,##0"));
        return s;
    }

    private CellStyle normalStyle(XSSFWorkbook wb) {
        CellStyle s = wb.createCellStyle();
        s.setBorderBottom(BorderStyle.THIN);
        s.setBorderTop(BorderStyle.THIN);
        s.setBorderLeft(BorderStyle.THIN);
        s.setBorderRight(BorderStyle.THIN);
        return s;
    }

    private void createCell(Row row, int col, String val, CellStyle style) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(style);
    }

    private void createCell(Row row, int col, double val, CellStyle style) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(style);
    }

    private void createCell(Row row, int col, int val, CellStyle style) {
        Cell c = row.createCell(col);
        c.setCellValue(val);
        c.setCellStyle(style);
    }

    private void autoSize(Sheet sheet, int cols) {
        for (int i = 0; i < cols; i++) {
            sheet.autoSizeColumn(i);
            int w = sheet.getColumnWidth(i);
            sheet.setColumnWidth(i, Math.min(w + 1024, 15000));
        }
    }

    private byte[] toBytes(XSSFWorkbook wb) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        wb.write(out);
        return out.toByteArray();
    }
}
