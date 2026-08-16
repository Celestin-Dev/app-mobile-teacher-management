package com.teacher.manager.repository;

import com.teacher.manager.model.Teacher;
import com.teacher.manager.model.TeacherSubject;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TeacherRepository extends JpaRepository<Teacher, Long> {

    // Recherche d'enseignants par nom ou prénom
    @Query("SELECT t FROM Teacher t WHERE " +
            "LOWER(t.firstName) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
            "LOWER(t.lastName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Teacher> searchByName(@Param("name") String name);

    // Enseignants ayant au moins une matière dans le parcours donné
    @Query("SELECT DISTINCT t FROM Teacher t " +
            "JOIN t.teacherSubjects ts " +
            "JOIN ts.subject s " +
            "JOIN s.group g " +
            "WHERE UPPER(g.code) = UPPER(:groupCode)")
    List<Teacher> findByGroupCode(@Param("groupCode") String groupCode);

}