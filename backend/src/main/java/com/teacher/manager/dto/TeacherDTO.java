package com.teacher.manager.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TeacherDTO {
  private Long id;
  private String matricule;
  private String firstName;
  private String lastName;
  private String email;
  private String phone;
  private String grade;
  private String specialty;
  private String photo;
}