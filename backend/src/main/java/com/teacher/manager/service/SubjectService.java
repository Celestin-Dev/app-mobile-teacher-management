package com.teacher.manager.service;

import com.teacher.manager.dto.SubjectDTO;
import com.teacher.manager.dto.UpdateSubjectRequest;
import com.teacher.manager.exception.ResourceNotFoundException;
import com.teacher.manager.mapper.TeacherMapper;
import com.teacher.manager.model.Group;
import com.teacher.manager.model.Subject;
import com.teacher.manager.model.TeacherSubject;
import com.teacher.manager.repository.GroupRepository;
import com.teacher.manager.repository.SubjectRepository;
import com.teacher.manager.repository.TeacherSubjectRepository;
import com.teacher.manager.interfaces.SubjectInterface;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SubjectService implements SubjectInterface {

  private final SubjectRepository subjectRepository;
  private final GroupRepository groupRepository;
  private final TeacherSubjectRepository teacherSubjectRepository;

  @Override
  @Transactional
  public SubjectDTO updateSubject(Long subjectId, UpdateSubjectRequest request) {
    Subject subject = subjectRepository.findById(subjectId)
        .orElseThrow(() -> new ResourceNotFoundException(
            "Matière introuvable avec l'id : " + subjectId));

    subject.setName(request.getName());
    subject.setCredits(request.getCredits());

    if (request.getGroupId() != null) {
      Group group = groupRepository.findById(request.getGroupId())
          .orElseThrow(() -> new ResourceNotFoundException(
              "Parcours introuvable avec l'id : " + request.getGroupId()));
      subject.setGroup(group);
    }

    Subject saved = subjectRepository.save(subject);
    return TeacherMapper.toSubjectDTO(saved);
  }

  @Override
  @Transactional
  public void removeSubjectFromTeacher(Long teacherId, Long subjectId) {
    TeacherSubject link = teacherSubjectRepository
        .findByTeacherIdAndSubjectId(teacherId, subjectId)
        .orElseThrow(() -> new ResourceNotFoundException(
            "Aucune attribution trouvée pour cet enseignant et cette matière"));

    teacherSubjectRepository.delete(link);
  }
}