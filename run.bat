@echo off
title "Student Admission & Enrollment Management System"
cls
echo =========================================================================
echo       STUDENT ADMISSION ^& ENROLLMENT MANAGEMENT SYSTEM - LAUNCHER
echo =========================================================================
echo.
echo Checking Java and Maven environment...

java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java is not detected in your environment.
    echo Please install JDK 17 or higher and add it to your system PATH.
    echo.
    goto manual_instructions
)

mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Maven is not detected in your system PATH.
    echo Attempting to compile and run using the project wrapper if present...
    echo.
)

echo [1] Compile and run with In-Memory H2 Database (Default, No setup required)
echo [2] Compile and run with Local MySQL Database (Requires MySQL setup)
echo [3] Exit
echo.
set /p choice="Select an option (1-3): "

if "%choice%"=="1" (
    echo.
    echo Building and starting application in DEV (H2 memory) mode...
    echo Running: mvn spring-boot:run
    call mvn spring-boot:run
    goto end
)

if "%choice%"=="2" (
    echo.
    echo Make sure you have created the schema 'student_admission_db' in MySQL
    echo and updated your credentials in src/main/resources/application.yml!
    echo.
    echo Building and starting application in MYSQL mode...
    echo Running: mvn spring-boot:run -Dspring-boot.run.profiles=mysql
    call mvn spring-boot:run -Dspring-boot.run.profiles=mysql
    goto end
)

if "%choice%"=="3" (
    exit /b 0
)

echo Invalid choice.
pause
goto end

:manual_instructions
echo =========================================================================
echo                        MANUAL RUN INSTRUCTIONS
echo =========================================================================
echo 1. Open your IDE (IntelliJ IDEA, Eclipse, NetBeans, or VS Code).
echo 2. Import this directory as a Maven project (select pom.xml).
echo 3. Ensure your IDE is configured with JDK 17.
echo 4. Run the main class: com.university.admission.AdmissionSystemApplication
echo 5. Access the portal at: http://localhost:8080/index.html
echo =========================================================================
echo.
pause

:end
