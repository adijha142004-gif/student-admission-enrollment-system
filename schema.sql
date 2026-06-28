-- Database Schema for Student Admission & Enrollment Management System
-- Database Name: student_admission_db
-- Target: MySQL 8.x / 5.7 / H2 Dialect Compatibility

-- -----------------------------------------------------
-- Table `users`
-- Roles: ROLE_STUDENT, ROLE_ADMIN, ROLE_VERIFIER
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `role` VARCHAR(20) NOT NULL,
    `status` VARCHAR(20) DEFAULT 'ACTIVE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `students`
-- Holds personal information of the registered student
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `gender` VARCHAR(15) NOT NULL,
    `phone` VARCHAR(15) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `admission_applications`
-- Lifecycle: DRAFT -> SUBMITTED -> UNDER_REVIEW -> DOCUMENT_VERIFIED / DOCUMENT_REJECTED -> APPROVED / REJECTED -> ENROLLED
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `admission_applications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `student_id` BIGINT NOT NULL,
    `program_name` VARCHAR(50) NOT NULL, -- e.g. ENGINEERING, BUSINESS, ARTS, SCIENCE
    `gpa` DOUBLE NOT NULL,
    `additional_test_score` DOUBLE DEFAULT 0.0,
    `admission_score` DOUBLE DEFAULT 0.0, -- Calculated dynamically using Strategy Design Pattern
    `status` VARCHAR(30) NOT NULL DEFAULT 'DRAFT',
    `remarks` VARCHAR(500),
    `submission_date` TIMESTAMP NULL DEFAULT NULL,
    `reviewed_by` BIGINT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_app_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_app_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `documents`
-- Verification Status: PENDING, VERIFIED, REJECTED
-- Document Type: IDENTITY_PROOF, ACADEMIC_TRANSCRIPT, INCOME_CERTIFICATE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `documents` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `application_id` BIGINT NOT NULL,
    `document_type` VARCHAR(50) NOT NULL,
    `document_url` VARCHAR(255) NOT NULL,
    `verification_status` VARCHAR(20) DEFAULT 'PENDING',
    `verification_remarks` VARCHAR(255) NULL,
    `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_app` FOREIGN KEY (`application_id`) REFERENCES `admission_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `enrollments`
-- Holds enrollment information of approved students
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `enrollments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `application_id` BIGINT NOT NULL UNIQUE,
    `enrollment_number` VARCHAR(50) NOT NULL UNIQUE,
    `enrollment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `academic_year` VARCHAR(15) NOT NULL,
    `status` VARCHAR(20) DEFAULT 'ACTIVE',
    CONSTRAINT `fk_enrollment_app` FOREIGN KEY (`application_id`) REFERENCES `admission_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
