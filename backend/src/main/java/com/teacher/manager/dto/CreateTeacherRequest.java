
package com.teacher.manager.dto;

import lombok.Data;

@Data
public class CreateTeacherRequest {
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private Long departmentId;
    private String specialty;
}
