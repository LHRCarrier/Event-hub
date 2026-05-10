package com.example.eventhub.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("redirect_url") != null) {
            return "redirect:" + session.getAttribute("redirect_url");
        }
        return "redirect:/login.jsp";
    }

    @GetMapping("/index.jsp")
    public String index() {
        return "redirect:/login.jsp";
    }
}
