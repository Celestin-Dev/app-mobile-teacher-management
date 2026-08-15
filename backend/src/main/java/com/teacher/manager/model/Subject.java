package com.teacher.manager.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "subjects")
@Data
public class Subject {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(unique = true, nullable = false)
  private String code;

  private String name;

  private int credits;

  @ManyToOne
  @JoinColumn(name = "group_id", nullable = false)
  private Group group;

  @OneToMany(mappedBy = "subject", cascade = jakarta.persistence.CascadeType.ALL)
  private List<TeacherSubject> teacherSubjects = new ArrayList<>();
}