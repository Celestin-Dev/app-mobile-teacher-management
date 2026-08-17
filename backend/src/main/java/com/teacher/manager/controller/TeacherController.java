package com.teacher.manager.controller;

import com.teacher.manager.dto.CreateTeacherRequest;
import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.TeacherDTO;
import com.teacher.manager.service.TeacherService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/teachers")
@RequiredArgsConstructor
public class TeacherController {

  private final TeacherService teacherService;

  // GET /api/teachers ou GET /api/teachers?group=xxx
  @GetMapping
  public ResponseEntity<List<TeacherDTO>> getAllTeachers(
      @RequestParam(required = false) String group) {

    List<TeacherDTO> teachers = (group != null && !group.isBlank())
        ? teacherService.getTeachersByGroup(group)
        : teacherService.getAllTeachers();

    return ResponseEntity.ok(teachers);
  }

  // GET /api/teachers/{id}
  @GetMapping("/{id}")
  public ResponseEntity<TeacherDTO> getTeacherById(@PathVariable Long id) {
    return ResponseEntity.ok(teacherService.getTeacherById(id));
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

  // POST
  @PostMapping
  public ResponseEntity<TeacherDTO> createTeacher(@RequestBody CreateTeacherRequest request) {
    TeacherDTO created = teacherService.createTeacher(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
  }

}