package com.example.notes.controller;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.notes.security.JwtUtil;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String username) {
        // Aqui poderia ser integrado com banco de dados
        String token = jwtUtil.generateToken(username);
        return ResponseEntity.ok(Collections.singletonMap("token", token));
    }
}
