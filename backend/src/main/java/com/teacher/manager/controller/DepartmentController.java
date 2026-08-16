package com.teacher.manager.controller;

import com.teacher.manager.dto.DepartmentDTO;
import com.teacher.manager.repository.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/departments")
@RequiredArgsConstructor
public class DepartmentController {

  private final DepartmentRepository departmentRepository;

  @GetMapping
  public ResponseEntity<List<DepartmentDTO>> getAllDepartments() {
    List<DepartmentDTO> departments = departmentRepository.findAll()
        .stream()
        .map(d -> new DepartmentDTO(d.getId(), d.getName()))
        .collect(Collectors.toList());
    return ResponseEntity.ok(departments);
  }
}