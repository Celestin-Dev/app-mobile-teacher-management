package com.teacher.manager.dto;

import lombok.Data;

@Data
public class UpdateSubjectRequest {
  private String name;
  private double credits;
  private Long groupId; // optionnel : permet de changer le parcours
}
