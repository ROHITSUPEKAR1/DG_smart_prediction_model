-- =============================================================
-- DG Smart School Management System — Complete Database Schema
-- MySQL 8.0+ | Multi-Tenant with school_id isolation
-- =============================================================

CREATE DATABASE IF NOT EXISTS `dg_smart` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `dg_smart`;

-- -----------------------------------------------------------
-- 1. SCHOOLS (Tenant Registry)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `schools` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `code` VARCHAR(50) NOT NULL UNIQUE,
  `address` TEXT,
  `contact_phone` VARCHAR(20),
  `contact_email` VARCHAR(100),
  `logo_url` VARCHAR(500),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 2. USERS (Teachers + Parents — unified login)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `mobile` VARCHAR(15) NOT NULL,
  `email` VARCHAR(100),
  `password_hash` VARCHAR(255) NOT NULL,
  `role` ENUM('teacher', 'parent') NOT NULL,
  `fcm_token` VARCHAR(500),
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_school_mobile` (`school_id`, `mobile`),
  KEY `idx_users_school_role` (`school_id`, `role`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 3. CLASSES
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `classes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `section` VARCHAR(10) NOT NULL DEFAULT 'A',
  `class_teacher_id` INT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_classes_school` (`school_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`class_teacher_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 4. STUDENTS
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `students` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `class_id` INT UNSIGNED NOT NULL,
  `parent_id` INT UNSIGNED,
  `roll_number` VARCHAR(20),
  `date_of_birth` DATE,
  `profile_photo` VARCHAR(500),
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_students_school_class` (`school_id`, `class_id`),
  KEY `idx_students_school_parent` (`school_id`, `parent_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`parent_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 5. ATTENDANCE
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `attendance` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `teacher_id` INT UNSIGNED NOT NULL,
  `class_id` INT UNSIGNED NOT NULL,
  `period_id` INT UNSIGNED DEFAULT NULL,
  `date` DATE NOT NULL,
  `status` ENUM('present', 'absent', 'late', 'excused') NOT NULL DEFAULT 'present',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_attendance_student_date_period` (`student_id`, `date`, `period_id`),
  KEY `idx_attendance_school_student_date` (`school_id`, `student_id`, `date`),
  KEY `idx_attendance_school_teacher` (`school_id`, `teacher_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 6. EXAMS
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `exams` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `exam_date` DATE,
  `max_marks` DECIMAL(6,2) DEFAULT 100,
  `weightage` DECIMAL(5,2) DEFAULT 100,
  `status` ENUM('draft', 'published') DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_exams_school` (`school_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 7. SUBJECTS (referenced by results)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `subjects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `code` VARCHAR(20),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_subjects_school` (`school_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 8. RESULTS (Marks/Grades)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `results` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `exam_id` INT UNSIGNED NOT NULL,
  `subject_id` INT UNSIGNED NOT NULL,
  `class_id` INT UNSIGNED,
  `marks` DECIMAL(6,2) DEFAULT 0,
  `internal_marks` DECIMAL(6,2),
  `external_marks` DECIMAL(6,2),
  `max_marks` DECIMAL(6,2) DEFAULT 100,
  `grade` VARCHAR(5),
  `percentage` DECIMAL(5,2),
  `status` ENUM('draft', 'published') DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_results_student_exam_subject` (`student_id`, `exam_id`, `subject_id`),
  KEY `idx_results_school_student` (`school_id`, `student_id`),
  KEY `idx_results_school_class_exam` (`school_id`, `class_id`, `exam_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`exam_id`) REFERENCES `exams`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 9. HOMEWORK
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `homework` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `teacher_id` INT UNSIGNED NOT NULL,
  `class_id` INT UNSIGNED NOT NULL,
  `subject` VARCHAR(100) NOT NULL,
  `caption` TEXT,
  `attachment_url` VARCHAR(500),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_homework_school_class` (`school_id`, `class_id`),
  KEY `idx_homework_school_teacher` (`school_id`, `teacher_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 10. FEE INSTALLMENTS
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fee_installments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `label` VARCHAR(100) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `due_date` DATE NOT NULL,
  `status` ENUM('PENDING', 'PAID', 'OVERDUE') DEFAULT 'PENDING',
  `paid_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fees_school_student` (`school_id`, `student_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 11. FEE TRANSACTIONS (Payment Log)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fee_transactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `installment_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `payment_mode` VARCHAR(30) DEFAULT 'ONLINE',
  `transaction_ref` VARCHAR(100),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fee_txn_school` (`school_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`installment_id`) REFERENCES `fee_installments`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 12. MEETINGS (PTM Booking)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `meetings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `parent_id` INT UNSIGNED NOT NULL,
  `teacher_id` INT UNSIGNED NOT NULL,
  `start_time` DATETIME NOT NULL,
  `notes` TEXT,
  `status` ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
  `meeting_link` VARCHAR(500),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_meetings_school_teacher` (`school_id`, `teacher_id`),
  KEY `idx_meetings_school_parent` (`school_id`, `parent_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`parent_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`teacher_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 13. NOTIFICATIONS (In-App Notification Log)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `title` VARCHAR(255),
  `message` TEXT,
  `priority` ENUM('normal', 'high', 'critical') DEFAULT 'normal',
  `is_read` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_school_student` (`school_id`, `student_id`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
-- 14. RISK ASSESSMENTS (Predictive AI Engine)
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `risk_assessments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `school_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `risk_type` ENUM('attendance', 'academic', 'fee') NOT NULL,
  `severity` ENUM('low', 'high') NOT NULL DEFAULT 'low',
  `description` TEXT,
  `notified` TINYINT(1) DEFAULT 0,
  `resolved` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_risks_school_student_status` (`school_id`, `student_id`, `resolved`),
  FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================================
-- SEED DATA (Demo School for Testing)
-- =============================================================

-- 1. Insert a Demo School
INSERT INTO `schools` (`id`, `name`, `code`, `address`, `contact_phone`, `contact_email`) VALUES
(1, 'DreamsGuider Academy', 'DGA001', '123 Education Lane, New Delhi', '9876543210', 'admin@dreamsguider.com');

-- 2. Insert Demo Users (password = "test123" hashed with bcrypt)
-- bcrypt hash for "test123": $2a$10$rKN8qveKpc9KxhC1bTkXnuJ8F8eVK5D2Nv8Rz.DGgm8gKzGh5pW9O
INSERT INTO `users` (`id`, `school_id`, `name`, `mobile`, `password_hash`, `role`) VALUES
(1, 1, 'John Mitchell', '9999999991', '$2a$10$rKN8qveKpc9KxhC1bTkXnuJ8F8eVK5D2Nv8Rz.DGgm8gKzGh5pW9O', 'teacher'),
(2, 1, 'Sarah Sharma', '9999999992', '$2a$10$rKN8qveKpc9KxhC1bTkXnuJ8F8eVK5D2Nv8Rz.DGgm8gKzGh5pW9O', 'parent');

-- 3. Insert Demo Classes
INSERT INTO `classes` (`id`, `school_id`, `name`, `section`, `class_teacher_id`) VALUES
(1, 1, '10', 'A', 1),
(2, 1, '5', 'C', NULL),
(3, 1, '11', 'B', NULL),
(4, 1, '12', 'A', NULL);

-- 4. Insert Demo Students
INSERT INTO `students` (`id`, `school_id`, `first_name`, `last_name`, `class_id`, `parent_id`, `roll_number`) VALUES
(1, 1, 'Aditya', 'Sharma', 1, 2, '10A-01'),
(2, 1, 'Esha', 'Sharma', 2, 2, '5C-15');

-- 5. Insert Demo Subjects
INSERT INTO `subjects` (`id`, `school_id`, `name`, `code`) VALUES
(1, 1, 'Mathematics', 'MATH'),
(2, 1, 'Science', 'SCI'),
(3, 1, 'English', 'ENG'),
(4, 1, 'History', 'HIST'),
(5, 1, 'Computer Science', 'CS');

-- 6. Insert Demo Exam
INSERT INTO `exams` (`id`, `school_id`, `name`, `exam_date`, `status`) VALUES
(1, 1, 'Unit Test 1', '2026-02-15', 'published'),
(2, 1, 'Midterm', '2026-02-28', 'published');

-- 7. Insert Demo Attendance (last 5 days for Aditya)
INSERT INTO `attendance` (`school_id`, `student_id`, `teacher_id`, `class_id`, `date`, `status`) VALUES
(1, 1, 1, 1, CURDATE(), 'present'),
(1, 1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'present'),
(1, 1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'absent'),
(1, 1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'present'),
(1, 1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'present'),
(1, 2, 1, 2, CURDATE(), 'absent');

-- 8. Insert Demo Fee Installments
INSERT INTO `fee_installments` (`school_id`, `student_id`, `label`, `amount`, `due_date`, `status`) VALUES
(1, 1, 'Q1 Tuition Fee', 15000.00, '2026-04-01', 'PENDING'),
(1, 1, 'Q2 Tuition Fee', 15000.00, '2026-07-01', 'PENDING'),
(1, 2, 'Q1 Tuition Fee', 12000.00, '2026-04-01', 'PENDING');

-- =============================================================
-- DONE! Run this file with:
-- mysql -u root -p < schema.sql
-- =============================================================
