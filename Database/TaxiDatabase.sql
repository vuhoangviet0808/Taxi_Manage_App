drop database if exists taxi_management_app;
create database taxi_management_app;
use taxi_management_app;

CREATE TABLE Account (
    SDT VARCHAR(20) PRIMARY KEY,
    password VARCHAR(255),
    roles ENUM('admin', 'driver', 'user') NOT NULL DEFAULT 'user',
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE User (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    SDT VARCHAR(20),
    Firstname VARCHAR(255),
    Lastname VARCHAR(255),
    Wallet DECIMAL(10, 2) DEFAULT 0,
    DOB DATE,
    Gender ENUM('Nam', 'Nữ'),
    Address TEXT,
    CCCD VARCHAR(20),
    user_token VARCHAR(255) NULL,
    FOREIGN KEY(SDT) REFERENCES Account(SDT)
);

CREATE TABLE Driver (
    Driver_ID INT PRIMARY KEY AUTO_INCREMENT,
    SDT VARCHAR(20),
    Firstname VARCHAR(255),
    Lastname VARCHAR(255),
    Wallet DECIMAL(10, 2) DEFAULT 0,
    DOB DATE,
    Gender ENUM('Nam', 'Nữ'),
    Address TEXT,
    CCCD VARCHAR(20),
    Driving_licence_number VARCHAR(20),
    Working_experiment DECIMAL(5, 2) DEFAULT 0,
    driver_token VARCHAR(255) NULL,
    FOREIGN KEY(SDT) REFERENCES Account(SDT)
);

CREATE TABLE Cab (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    licence_plate VARCHAR(20),
    car_type ENUM('4_seat', '6_seat') NOT NULL, -- Thêm thuộc tính car_type
    manufacture_year INT,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE Shift (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Driver_id INT,
    cab_id INT,
    current_gps_location POINT,
    current_address TEXT,
    evaluate DECIMAL(2, 1),
    FOREIGN KEY(Driver_id) REFERENCES Driver(Driver_ID),
    FOREIGN KEY(cab_id) REFERENCES Cab(ID)
);

CREATE TABLE cab_ride (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    shift_id INT,
    user_id INT,
    ride_start_time DATETIME,
    ride_end_time DATETIME,
    address_starting_point TEXT,
    GPS_starting_point POINT,
    address_destination TEXT,
    GPS_destination POINT,
    status ENUM('in_progress', 'cancelled', 'completed') NOT NULL,
    cancelled_by ENUM('user', 'driver', 'system') NULL,
    price DECIMAL(10,2),
    response TEXT,
    evaluate DECIMAL(2, 1),
    FOREIGN KEY(shift_id) REFERENCES Shift(ID),
    FOREIGN KEY(user_id) REFERENCES User(User_ID)
);

CREATE TABLE booking_requests (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    requested_car_type ENUM('4_seat', '6_seat'),
    pickup_location VARCHAR(255),
    dropoff_location VARCHAR(255),
    gps_pick_up_location POINT,
    gps_destination_location POINT, 
    price DECIMAL(10,2),
    request_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'assigned', 'cancelled') DEFAULT 'pending',
    driver_id INT NULL,
    FOREIGN KEY(user_id) REFERENCES User(User_ID),
    FOREIGN KEY(driver_id) REFERENCES Driver(Driver_ID) ON DELETE SET NULL
);






