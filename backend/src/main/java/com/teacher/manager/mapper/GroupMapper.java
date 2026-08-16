package com.teacher.manager.mapper;

import com.teacher.manager.dto.GroupDTO;
import com.teacher.manager.model.Group;

public class GroupMapper {
  public static GroupDTO toDTO(Group group) {
    return new GroupDTO(
        group.getId(),
        group.getCode(),
        group.getName(),
        group.getLevel().name());
  }
}