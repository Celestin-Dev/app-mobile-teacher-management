package com.teacher.manager.controller;

import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.TeacherDTO;
import com.teacher.manager.service.TeacherService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/teachers")
@RequiredArgsConstructor
public class TeacherController {

  private final TeacherService teacherService;

  // GET /api/teachers
  @GetMapping
  public ResponseEntity<List<TeacherDTO>> getAllTeachers() {
    return ResponseEntity.ok(teacherService.getAllTeachers());
  }

  // GET /api/teachers/{id}/subjects
  @GetMapping("/{id}/subjects")
  public ResponseEntity<List<SubjectDTO>> getSubjectsByTeacherId(@PathVariable Long id) {
    return ResponseEntity.ok(teacherService.getSubjectsByTeacherId(id));
  }

  // GET /api/teachers/search?name=xxx
  @GetMapping("/search")
  public ResponseEntity<List<TeacherDTO>> searchTeachers(@RequestParam String name) {
    return ResponseEntity.ok(teacherService.searchTeachersByName(name));
  }
}