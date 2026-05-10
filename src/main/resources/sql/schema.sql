-- Create database if not exists
CREATE DATABASE IF NOT EXISTS eventhub;
USE eventhub;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    real_name VARCHAR(50),
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Events Table
CREATE TABLE IF NOT EXISTS events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    date DATETIME NOT NULL,
    location VARCHAR(200) NOT NULL,
    description TEXT,
    category_id INT,
    status VARCHAR(20) NOT NULL DEFAULT 'UPCOMING',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- Registrations Table
CREATE TABLE IF NOT EXISTS registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'REGISTERED',
    register_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_registration (event_id, user_id)
);

-- Insert default admin user
INSERT INTO users (username, password, email, role, status) VALUES 
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjzqAKL9xL5jvMFVdNJHvGCgTq/VEq', 'admin@eventhub.com', 'ADMIN', 'ACTIVE');

-- Insert default categories
INSERT INTO categories (name, description) VALUES 
('Tech', 'Technology workshops & talks'),
('Sports', 'Sports activities & games'),
('Cultural', 'Cultural events & festivals'),
('Art', 'Art exhibitions & workshops'),
('Workshop', 'Educational workshops'),
('Music', 'Music events & concerts'),
('Food', 'Food festivals & tasting events'),
('Community', 'Community gatherings');

-- Insert sample events
INSERT INTO events (name, date, location, description, category_id, status) VALUES 
('Tech Workshop 2024', '2024-05-15 10:00:00', 'Community Center', 'Learn the latest technologies including cloud computing and AI.', 1, 'UPCOMING'),
('Sports Day 2024', '2024-05-20 09:00:00', 'City Stadium', 'Annual sports day with various games and competitions.', 2, 'UPCOMING'),
('Cultural Night', '2024-05-25 18:00:00', 'Town Hall', 'Experience traditional music, dance, and art from around the world.', 3, 'UPCOMING'),
('Art Exhibition', '2024-05-30 10:00:00', 'Art Gallery', 'A showcase of local artists'' finest works.', 4, 'UPCOMING'),
('Music Festival', '2024-04-10 12:00:00', 'Central Park', 'A day of live music featuring local bands.', 6, 'PAST');