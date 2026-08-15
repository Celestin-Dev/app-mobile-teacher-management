package com.teacher.manager.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "teachers")
@Data
public class Teacher {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name = "matricule", unique = true, nullable = false)
  private String matricule;

  private String firstName;
  private String lastName;

  @Column(name = "email", unique = true, nullable = true)
  private String email;

  private String phone;
  private String grade;
  private String specialty;
  private String photo;
  private Long departmentId;

  @OneToMany(mappedBy = "teacher", cascade = jakarta.persistence.CascadeType.ALL)
  private List<TeacherSubject> teacherSubjects = new ArrayList<>();
}