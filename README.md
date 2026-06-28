# Student Admission & Enrollment Management System

Welcome to the **Student Admission & Enrollment Management System** ("EduEnroll Hub"). This project is a full-featured, enterprise-grade Spring Boot application designed to manage the entire lifecycle of student admissions: from initial student registration and application submission, through document verification, dynamic Strategy-pattern criteria evaluations, and final enrollment generation.

---

## 📌 Submission Contents
- **Source Code**: Spring Boot 3.x maven project with complete implementation (Auth, Documents, Evaluation Strategy, Enrollment).
- **Database Scripts**: Raw SQL DDL/DML scripts in `db_scripts/` (for MySQL) and a dynamic in-code `DatabaseSeeder` that runs automatically for H2/MySQL.
- **API Documentation**: Integrated interactive Swagger UI and a pre-packaged Postman Collection (`postman/`).
- **Interactive UI Dashboard**: A gorgeous, single-page glassmorphic Web Dashboard served directly at `http://localhost:8080/index.html`.

---

## 🛠️ Technology Stack
- **Backend Framework**: Spring Boot 3.2.5
- **Build System**: Maven (wrapper included)
- **Security**: Spring Security 6 with JSON Web Token (JWT)
- **Persistence**: Spring Data JPA & Hibernate
- **Database**: MySQL 8.x (production) / H2 In-Memory Database (development/testing)
- **API Documentation**: Springdoc OpenAPI / Swagger UI
- **Frontend Dashboard**: HTML5, Vanilla CSS3 (Custom HSL Dark Mode & Glassmorphic variables), JavaScript, Chart.js

---

## 📐 Database Design
The relational schema structure comprises:
1. **Users**: Houses credentials, BCrypt-encoded passwords, emails, and roles (`ROLE_STUDENT`, `ROLE_VERIFIER`, `ROLE_ADMIN`).
2. **Students**: Holds personal information, linked `1-to-1` to a credentials user account.
3. **Admission Applications**: Captures Chosen Program, high school GPA, entrance test score, calculated admission score, and lifecycle status (`DRAFT`, `SUBMITTED`, `UNDER_REVIEW`, `DOCUMENT_VERIFIED`, `DOCUMENT_REJECTED`, `APPROVED`, `REJECTED`, `ENROLLED`).
4. **Documents**: Tracks files (transcripts/IDs) uploaded by the student with individual verification checks (`PENDING`, `VERIFIED`, `REJECTED`).
5. **Enrollments**: Connects uniquely to approved applications and holds official registration numbers and academic years.

---

## 🧩 Strategy Design Pattern
Admissions scoring and eligibility vary by program. Rather than using complex `if-else` blocks in controllers, the application utilizes the **Strategy Pattern**:

```
                  ┌──────────────────────────────┐
                  │      EvaluationStrategy      │
                  └──────────────┬───────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
┌──────────────────┐   ┌──────────────────┐    ┌──────────────────┐
│EngineeringStrat  │   │  BusinessStrat   │    │    ArtsStrat     │
└──────────────────┘   └──────────────────┘    └──────────────────┘
```

- **Engineering Strategy**: Checks `GPA >= 3.0` & `Math Score >= 60`. Formula: `(GPA * 20) + (TestScore * 0.2)`.
- **Business Strategy**: Checks `GPA >= 2.8` & `English Score >= 50`. Formula: `(GPA * 22) + (TestScore * 0.12)`.
- **Arts Strategy**: Checks `GPA >= 2.0` & `Portfolio Score >= 40`. Formula: `(GPA * 15) + (TestScore * 0.4)`.

The `EvaluationContext` bean resolves the appropriate strategy at runtime:
```java
EvaluationStrategy strategy = strategies.stream()
    .filter(s -> s.supports(programName))
    .findFirst()
    .orElseThrow();
```

---

## 🔌 API Endpoints
All endpoints require a JWT bearer token except Authentication.

### 🔑 Authentication (`/api/auth`)
- `POST /api/auth/register` - Create new student login profile.
- `POST /api/auth/login` - Authenticate and return JWT token.

### 📄 Applications (`/api/applications`)
- `POST /api/applications` - Submit an application draft (Role: `STUDENT`).
- `POST /api/applications/{id}/documents` - Upload credentials (Role: `STUDENT`).
- `GET /api/applications/my` - Fetch logged-in student's applications (Role: `STUDENT`).
- `GET /api/applications` - Filter and search applications (Roles: `VERIFIER`, `ADMIN`).
- `GET /api/applications/{id}` - Fetch application detailed record (Roles: `STUDENT`, `VERIFIER`, `ADMIN`).
- `PUT /api/applications/{appId}/documents/{docId}/verify` - Review and verify document (Role: `VERIFIER`).
- `POST /api/applications/{id}/evaluate` - Score and decide admission application (Role: `ADMIN`).

### 🎓 Enrollments (`/api/enrollments`)
- `POST /api/enrollments/applications/{appId}/enroll` - Issue student registration number (Role: `ADMIN`).
- `GET /api/enrollments/{enrollmentNumber}` - Search enrollment verification (Roles: `VERIFIER`, `ADMIN`).

### 📊 Dashboard (`/api/dashboard`)
- `GET /api/dashboard/stats` - Fetch KPIs and aggregate charts data (Role: `ADMIN`).
