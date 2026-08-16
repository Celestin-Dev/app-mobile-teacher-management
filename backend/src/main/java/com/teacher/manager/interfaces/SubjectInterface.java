// service/SubjectService.java
package com.teacher.manager.interfaces;

import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.UpdateSubjectRequest;

public interface SubjectInterface {
  SubjectDTO updateSubject(Long subjectId, UpdateSubjectRequest request);

  void removeSubjectFromTeacher(Long teacherId, Long subjectId);
}