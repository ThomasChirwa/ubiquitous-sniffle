-- Step 1: Create the Database
CREATE DATABASE TaskManagementDB;
USE TaskManagementDB;

-- Step 2: Create Tables
-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teams Table
CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User-Team Relationship (Many-to-Many)
CREATE TABLE UserTeams (
    user_id INT,
    team_id INT,
    role ENUM('Member', 'Admin') DEFAULT 'Member',
    PRIMARY KEY (user_id, team_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE CASCADE
);

-- Tasks Table
CREATE TABLE Tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority ENUM('High', 'Medium', 'Low') NOT NULL,
    status ENUM('To Do', 'In Progress', 'Done') DEFAULT 'To Do',
    assigned_to INT,
    team_id INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (assigned_to) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Comments Table
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Step 3: Insert Sample Data
-- Insert Users
INSERT INTO Users (username, email, password_hash) VALUES
('Chris_Raymond','chrisraymond@gmail.comm', 'hashed_password2'),
('Heckson_Chamutanga', 'hecksonchamutanga@gmail.com', 'hashed_password1');

-- Insert Teams
INSERT INTO Teams (team_name) VALUES
('Development Team'),
('Marketing Team');

-- Assign Users to Teams
INSERT INTO UserTeams (user_id, team_id, role) VALUES
(1, 1, 'Admin'),
(2, 1, 'Member'),
(2, 2, 'Admin');

-- Insert Tasks
INSERT INTO Tasks (title, description, priority, status, assigned_to, team_id, created_by) VALUES
('Design API', 'Create the API structure', 'High', 'To Do', 1, 1, 1),
('Setup Database', 'Initialize MySQL database', 'Medium', 'In Progress', 2, 1, 1);

-- Insert Comments
INSERT INTO Comments (task_id, user_id, content) VALUES
(1, 2, 'I have started working on the API.'),
(2, 1, 'Database setup is halfway done.');

-- Step 4: Sample Queries
-- Retrieve all tasks for a team
SELECT * FROM Tasks WHERE team_id = 1;

-- Get task details with assigned user
SELECT t.task_id, t.title, t.priority, t.status, u.username AS assigned_user
FROM Tasks t
LEFT JOIN Users u ON t.assigned_to = u.user_id;

-- Get comments on a task
SELECT c.content, u.username, c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.user_id
WHERE c.task_id = 1;


