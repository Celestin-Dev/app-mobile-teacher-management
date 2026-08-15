package com.teacher.manager.model;

import com.teacher.manager.enums.LevelEnum;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.GenerationType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "groups")
@Data
public class Group {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(unique = true, nullable = false)
  private String code;

  private String name; // OCC

  @Enumerated(EnumType.STRING)
  private LevelEnum level;

  @OneToMany(mappedBy = "group", cascade = jakarta.persistence.CascadeType.ALL)
  private List<Subject> subjects = new ArrayList<>();
}