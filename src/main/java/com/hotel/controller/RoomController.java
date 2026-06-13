package com.hotel.controller;

import com.hotel.model.Room;
import com.hotel.service.RoomService;
import com.hotel.service.RoomTypeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/rooms")
public class RoomController {
    private final RoomService roomService;
    private final RoomTypeService roomTypeService;

    public RoomController(RoomService roomService, RoomTypeService roomTypeService) {
        this.roomService = roomService;
        this.roomTypeService = roomTypeService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("rooms", roomService.findAll());
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
    public String save(@ModelAttribute Room room) {
        roomService.save(room);
        return "redirect:/admin/rooms";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        roomService.delete(id);
        return "redirect:/admin/rooms";
    }
}
