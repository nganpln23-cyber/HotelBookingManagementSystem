package com.hotel.controller;

import com.hotel.model.RoomType;
import com.hotel.service.RoomTypeService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/room-types")
public class RoomTypeController {
    private final RoomTypeService roomTypeService;

    public RoomTypeController(RoomTypeService roomTypeService) {
        this.roomTypeService = roomTypeService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("roomTypes", roomTypeService.findAll());
        return "room-types/list";
    }

    @GetMapping("/new")
    public String create(Model model) {
        model.addAttribute("roomType", new RoomType());
        return "room-types/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        model.addAttribute("roomType", roomTypeService.findById(id));
        return "room-types/form";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute RoomType roomType, BindingResult result,
                        @RequestParam(name = "imageFile", required = false) MultipartFile imageFile,
                        Model model) {
        if (result.hasErrors()) {
            model.addAttribute("error", result.getFieldErrors().stream()
                    .map(fe -> fe.getDefaultMessage())
                    .collect(Collectors.joining(" | ")));
            return "room-types/form";
        }
        roomTypeService.save(roomType, imageFile);
        return "redirect:/admin/room-types";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        roomTypeService.delete(id);
        return "redirect:/admin/room-types";
    }
}
