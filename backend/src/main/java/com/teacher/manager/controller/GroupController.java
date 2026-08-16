// controller/GroupController.java
package com.teacher.manager.controller;

import com.teacher.manager.dto.GroupDTO;
import com.teacher.manager.mapper.GroupMapper;
import com.teacher.manager.repository.GroupRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/groups")
@RequiredArgsConstructor
public class GroupController {

  private final GroupRepository groupRepository;

  @GetMapping
  public ResponseEntity<List<GroupDTO>> getAllGroups() {
    List<GroupDTO> groups = groupRepository.findAll()
        .stream()
        .map(GroupMapper::toDTO)
        .collect(Collectors.toList());
    return ResponseEntity.ok(groups);
  }
}