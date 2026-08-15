package com.teacher.manager.service;

import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.TeacherDTO;
import com.teacher.manager.exception.ResourceNotFoundException;
import com.teacher.manager.mapper.TeacherMapper;
import com.teacher.manager.model.Teacher;
import com.teacher.manager.model.TeacherSubject;
import com.teacher.manager.repository.TeacherRepository;
import com.teacher.manager.repository.TeacherSubjectRepository;
import com.teacher.manager.interfaces.TeacherInterface;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TeacherService implements TeacherInterface {

  private final TeacherRepository teacherRepository;
  private final TeacherSubjectRepository teacherSubjectRepository;

  @Override
  public List<TeacherDTO> getAllTeachers() {
    return teacherRepository.findAll()
        .stream()
        .map(TeacherMapper::toDTO)
        .collect(Collectors.toList());
  }

  @Override
  public List<SubjectDTO> getSubjectsByTeacherId(Long teacherId) {
    // Vérifie que l'enseignant existe, sinon exception
    Teacher teacher = teacherRepository.findById(teacherId)
        .orElseThrow(() -> new ResourceNotFoundException(
            "Enseignant introuvable avec l'id : " + teacherId));

    List<TeacherSubject> teacherSubjects = teacherSubjectRepository.findByTeacherId(teacher.getId());

    return teacherSubjects.stream()
        .map(ts -> TeacherMapper.toSubjectDTO(ts.getSubject()))
        .collect(Collectors.toList());
  }

  @Override
  public List<TeacherDTO> searchTeachersByName(String name) {
    return teacherRepository.searchByName(name)
        .stream()
        .map(TeacherMapper::toDTO)
        .collect(Collectors.toList());
  }
}