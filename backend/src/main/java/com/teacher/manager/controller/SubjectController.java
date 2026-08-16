package com.teacher.manager.controller;

import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.UpdateSubjectRequest;
import com.teacher.manager.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class SubjectController {

  private final SubjectService subjectService;

  // Modification d'une matière
  @PutMapping("/api/subjects/{id}")
  public ResponseEntity<SubjectDTO> updateSubject(
      @PathVariable Long id,
      @RequestBody UpdateSubjectRequest request) {
    return ResponseEntity.ok(subjectService.updateSubject(id, request));
  }

  // Suppression de l'attribution matière ↔ enseignant (pas la matière elle-même)
  @DeleteMapping("/api/teachers/{teacherId}/subjects/{subjectId}")
  public ResponseEntity<Void> removeSubjectFromTeacher(
      @PathVariable Long teacherId,
      @PathVariable Long subjectId) {
    subjectService.removeSubjectFromTeacher(teacherId, subjectId);
    return ResponseEntity.noContent().build();
  }
}