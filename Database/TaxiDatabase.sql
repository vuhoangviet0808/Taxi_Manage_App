drop database if exists taxi_management_app;
create database taxi_management_app;
use taxi_management_app;

create table Account(
	SDT varchar(20) primary key,
    password varchar(50),
    roles ENUM('admin','driver','user') NOT NULL DEFAULT 'user',
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    created_at DATE
);

create table User(
	User_ID int primary key auto_increment,
    SDT varchar(20),
    Firstname nvarchar(255),
    Lastname nvarchar(255),
    Wallet int default 0,
    DOB date,
    Gender ENUM('Nam','Nữ'),
    Address text,
    CCCD varchar(20),
    foreign key(SDT) references Account(SDT)
);

create table Driver (
	Driver_ID int primary key auto_increment,
    SDT varchar(20),
     Firstname nvarchar(255),
    Lastname nvarchar(255),
    Wallet int default 0,
    DOB date,
    Gender ENUM('Nam','Nữ'),
    Address text,
    CCCD varchar(20),
    Driving_licence_number varchar(20),
    Working_experiment int default 0,
    foreign key(SDT) references Account(SDT)
);

create table car_model(
	ID int primary key auto_increment,
    model_name nvarchar(255),
    model_description text
);

create table Cab (
	ID int primary key auto_increment,
    licence_plate varchar(20),
    car_model_id int,
    manufacture_year int,
    active boolean default true,
    foreign key (car_model_id) references car_model(ID)
);


create table Shift (
	ID int primary key auto_increment,
    Driver_id int,
    cab_id int,
    shift_start_time datetime,
    shift_end_time datetime,
    login_time datetime,
    logout_time datetime,
    foreign key(Driver_id) references Driver(Driver_ID),
    foreign key(cab_id) references Cab(ID)
);

create table payment_type (
	ID int primary key auto_increment,
    type_name nvarchar(255)
);

create table status (
	ID int primary key auto_increment,
    status_name nvarchar(255)
);

create table cc_agent(
	ID int primary key auto_increment,
    first_name nvarchar(255),
    last_name nvarchar(255)
);

CREATE TABLE cab_ride (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    shift_id INT,
    user_id INT,
    ride_start_time DATETIME,
    ride_end_time DATETIME,
    address_starting_point text,
    GPS_starting_point text,
    address_destination text,
    GPS_destination text,
    canceled BOOLEAN,
    payment_type_id INT,
    price DECIMAL(10,2),
    response TEXT,
    evaluate TEXT,
    foreign key(shift_id) references shift(ID),
    foreign key(user_id) references User(User_ID),
    foreign key(payment_type_id) references payment_type(ID)
);



create table cab_ride_status (
	ID int primary key auto_increment,
    cab_ride_id int,
    status_id int,
    status_time datetime,
    cc_agent_id int,
    status_detail text,
    foreign key(cab_ride_id) references cab_ride(ID),
    foreign key(status_id) references status(ID),
    foreign key(cc_agent_id) references cc_agent(ID)
);





