package com.teacher.manager.interfaces;

import com.teacher.manager.dto.CreateTeacherRequest;
import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.TeacherDTO;

import java.util.List;

public interface TeacherInterface {

  List<TeacherDTO> getAllTeachers();

  List<SubjectDTO> getSubjectsByTeacherId(Long teacherId);

  TeacherDTO getTeacherById(Long id);

  List<TeacherDTO> searchTeachersByName(String name);

  List<TeacherDTO> getTeachersByGroup(String groupCode);

  TeacherDTO createTeacher(CreateTeacherRequest request);
}