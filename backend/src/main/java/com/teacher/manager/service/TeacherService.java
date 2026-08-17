package com.teacher.manager.service;

import com.teacher.manager.dto.CreateTeacherRequest;
import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.TeacherDTO;
import com.teacher.manager.exception.ResourceNotFoundException;
import com.teacher.manager.mapper.TeacherMapper;
import com.teacher.manager.model.Department;
import com.teacher.manager.model.Teacher;
import com.teacher.manager.model.TeacherSubject;
import com.teacher.manager.repository.DepartmentRepository;
import com.teacher.manager.repository.TeacherRepository;
import com.teacher.manager.repository.TeacherSubjectRepository;

import jakarta.transaction.Transactional;

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
  private final DepartmentRepository departmentRepository;

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

  @Override
  public TeacherDTO getTeacherById(Long id) {
    Teacher teacher = teacherRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException(
            "Enseignant introuvable avec l'id : " + id));
    return TeacherMapper.toDTO(teacher);
  }

  @Override
  public List<TeacherDTO> getTeachersByGroup(String groupCode) {
    return teacherRepository.findByGroupCode(groupCode)
        .stream()
        .map(TeacherMapper::toDTO)
        .collect(Collectors.toList());
  }

  @Override
  @Transactional
  public TeacherDTO createTeacher(CreateTeacherRequest request) {
    Department department = departmentRepository.findById(request.getDepartmentId())
        .orElseThrow(() -> new ResourceNotFoundException(
            "Département introuvable avec l'id : " + request.getDepartmentId()));

    Teacher teacher = new Teacher();
    teacher.setMatricule(generateMatricule());
    teacher.setFirstName(request.getFirstName());
    teacher.setLastName(request.getLastName());
    teacher.setEmail(request.getEmail());
    teacher.setPhone(request.getPhone());
    teacher.setSpecialty(request.getSpecialty());
    teacher.setDepartment(department);

    Teacher saved = teacherRepository.save(teacher);
    return TeacherMapper.toDTO(saved);
  }

  private String generateMatricule() {
    long count = teacherRepository.count() + 1;
    return String.format("ENI%03d", count);
  }
}