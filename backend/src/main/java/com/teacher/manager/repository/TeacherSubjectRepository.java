package com.teacher.manager.repository;

import com.teacher.manager.model.TeacherSubject;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional; // ← import manquant

public interface TeacherSubjectRepository extends JpaRepository<TeacherSubject, Long> {

  List<TeacherSubject> findByTeacherId(Long teacherId);

  Optional<TeacherSubject> findByTeacherIdAndSubjectId(Long teacherId, Long subjectId); // ← Optional<>
}