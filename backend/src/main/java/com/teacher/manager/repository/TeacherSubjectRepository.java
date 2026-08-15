package com.teacher.manager.repository;

import com.teacher.manager.model.TeacherSubject;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TeacherSubjectRepository extends JpaRepository<TeacherSubject, Long> {

  List<TeacherSubject> findByTeacherId(Long teacherId);
}