package com.teacher.manager.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.teacher.manager.model.Group;

public interface GroupRepository extends JpaRepository<Group, Long> {

}
