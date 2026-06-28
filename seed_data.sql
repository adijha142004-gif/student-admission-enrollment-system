-- Seed data for Student Admission & Enrollment Management System
-- Passwords are BCrypt hashed for 'password123' -> $2a$10$xFDt/fNfsL1F75PzI7Zgze7r2B6L81V.u3bC4Y/mB30T8W6T3aEea

-- 1. Insert Users
INSERT INTO `users` (`id`, `username`, `password`, `email`, `role`, `status`) VALUES
(1, 'admin_user', '$2a$10$xFDt/fNfsL1F75PzI7Zgze7r2B6L81V.u3bC4Y/mB30T8W6T3aEea', 'admin@university.edu', 'ROLE_ADMIN', 'ACTIVE'),
(2, 'verifier_user', '$2a$10$xFDt/fNfsL1F75PzI7Zgze7r2B6L81V.u3bC4Y/mB30T8W6T3aEea', 'verifier@university.edu', 'ROLE_VERIFIER', 'ACTIVE'),
(3, 'alice_student', '$2a$10$xFDt/fNfsL1F75PzI7Zgze7r2B6L81V.u3bC4Y/mB30T8W6T3aEea', 'alice@gmail.com', 'ROLE_STUDENT', 'ACTIVE'),
(4, 'bob_student', '$2a$10$xFDt/fNfsL1F75PzI7Zgze7r2B6L81V.u3bC4Y/mB30T8W6T3aEea', 'bob@gmail.com', 'ROLE_STUDENT', 'ACTIVE'),
(5, 'charlie_student', '$2a$10$xFDt/fNfsL1F75PzI7Zgze7r2B6L81V.u3bC4Y/mB30T8W6T3aEea', 'charlie@gmail.com', 'ROLE_STUDENT', 'ACTIVE');

-- 2. Insert Students
INSERT INTO `students` (`id`, `user_id`, `first_name`, `last_name`, `date_of_birth`, `gender`, `phone`, `address`) VALUES
(1, 3, 'Alice', 'Smith', '2004-05-12', 'Female', '1234567890', '123 University Ave, Boston'),
(2, 4, 'Bob', 'Jones', '2003-11-23', 'Male', '9876543210', '456 College Rd, New York'),
(3, 5, 'Charlie', 'Brown', '2005-01-30', 'Male', '5551234567', '789 Academy Lane, Chicago');

-- 3. Insert Admission Applications
-- Alice: Approved & Enrolled in Engineering
-- Bob: Under Document Review in Business
-- Charlie: Draft/Submitted in Arts
INSERT INTO `admission_applications` (`id`, `student_id`, `program_name`, `gpa`, `additional_test_score`, `admission_score`, `status`, `remarks`, `submission_date`, `reviewed_by`) VALUES
(1, 1, 'ENGINEERING', 3.8, 90.0, 94.0, 'ENROLLED', 'Academic criteria met. Credentials verified.', '2026-06-15 10:00:00', 1),
(2, 2, 'BUSINESS', 3.4, 85.0, 87.55, 'UNDER_REVIEW', 'Documents are under verification process.', '2026-06-18 14:30:00', 2),
(3, 3, 'ARTS', 2.9, 75.0, 73.5, 'SUBMITTED', 'Applied for Fall 2026.', '2026-06-20 09:15:00', NULL);

-- 4. Insert Documents for verification
INSERT INTO `documents` (`id`, `application_id`, `document_type`, `document_url`, `verification_status`, `verification_remarks`) VALUES
(1, 1, 'IDENTITY_PROOF', 'https://mock-storage.university.edu/docs/alice_id.pdf', 'VERIFIED', 'Passport verified successfully.'),
(2, 1, 'ACADEMIC_TRANSCRIPT', 'https://mock-storage.university.edu/docs/alice_transcript.pdf', 'VERIFIED', 'High school transcript verified.'),
(3, 2, 'IDENTITY_PROOF', 'https://mock-storage.university.edu/docs/bob_id.pdf', 'PENDING', NULL),
(4, 2, 'ACADEMIC_TRANSCRIPT', 'https://mock-storage.university.edu/docs/bob_transcript.pdf', 'PENDING', NULL),
(5, 3, 'IDENTITY_PROOF', 'https://mock-storage.university.edu/docs/charlie_id.pdf', 'PENDING', NULL),
(6, 3, 'ACADEMIC_TRANSCRIPT', 'https://mock-storage.university.edu/docs/charlie_transcript.pdf', 'PENDING', NULL),
(7, 3, 'INCOME_CERTIFICATE', 'https://mock-storage.university.edu/docs/charlie_income.pdf', 'PENDING', NULL);

-- 5. Insert Enrollment for Alice
INSERT INTO `enrollments` (`id`, `application_id`, `enrollment_number`, `enrollment_date`, `academic_year`, `status`) VALUES
(1, 1, 'ENR-2026-ENG-0001', '2026-06-16 11:00:00', '2026-2027', 'ACTIVE');
