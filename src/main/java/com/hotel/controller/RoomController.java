package com.hotel.controller;

import com.hotel.model.Room;
import com.hotel.service.BookingService;
import com.hotel.service.RoomService;
import com.hotel.service.RoomTypeService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/rooms")
public class RoomController {
    private final RoomService roomService;
    private final RoomTypeService roomTypeService;
    private final BookingService bookingService;

    public RoomController(RoomService roomService, RoomTypeService roomTypeService, BookingService bookingService) {
        this.roomService = roomService;
        this.roomTypeService = roomTypeService;
        this.bookingService = bookingService;
    }

    @GetMapping
    public String list(@RequestParam(name = "keyword", required = false) String keyword,
                       @RequestParam(name = "status", required = false) String status,
                       Model model) {
        model.addAttribute("rooms", roomService.search(keyword, status));
        model.addAttribute("keyword", keyword);
        model.addAttribute("filterStatus", status);
        return "rooms/list";
    }

    @GetMapping("/new")
    public String create(Model model) {
        Room room = new Room();
        room.setStatus("AVAILABLE");
        model.addAttribute("room", room);
        model.addAttribute("roomTypes", roomTypeService.findAll());
        return "rooms/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        model.addAttribute("room", roomService.findById(id));
        model.addAttribute("roomTypes", roomTypeService.findAll());
        return "rooms/form";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute Room room, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldErrors().stream()
                    .map(fe -> fe.getDefaultMessage())
                    .collect(Collectors.joining(" | ")));
            model.addAttribute("roomTypes", roomTypeService.findAll());
            return "rooms/form";
        }
        roomService.save(room);
        return "redirect:/admin/rooms";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        roomService.delete(id);
        return "redirect:/admin/rooms";
    }

    @GetMapping("/sync-status")
    public String syncStatus() {
        bookingService.syncAllRoomStatuses();
        return "redirect:/admin/rooms";
    }
}
