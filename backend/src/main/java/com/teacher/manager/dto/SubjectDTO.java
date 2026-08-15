package com.teacher.manager.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SubjectDTO {
  private Long id;
  private String code;
  private String name;
  private int credits;
  private Long groupId;
  private String groupName;
}