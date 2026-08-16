package com.teacher.manager.mapper;

import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.TeacherDTO;
import com.teacher.manager.model.Subject;
import com.teacher.manager.model.Teacher;

public class TeacherMapper {

  public static TeacherDTO toDTO(Teacher teacher) {
    return new TeacherDTO(
        teacher.getId(),
        teacher.getMatricule(),
        teacher.getFirstName(),
        teacher.getLastName(),
        teacher.getEmail(),
        teacher.getPhone(),
        teacher.getGrade(),
        teacher.getSpecialty(),
        teacher.getPhoto());
  }

  public static SubjectDTO toSubjectDTO(Subject subject) {
    return new SubjectDTO(
        subject.getId(),
        subject.getCode(),
        subject.getName(),
        subject.getCredits(),
        subject.getGroup() != null ? subject.getGroup().getId() : null,
        subject.getGroup() != null ? subject.getGroup().getName() : null);
  }
}
