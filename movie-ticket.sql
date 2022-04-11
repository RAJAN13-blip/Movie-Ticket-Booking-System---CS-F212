CREATE DATABASE `movietickets` /*!40100 DEFAULT CHARACTER SET
utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT
ENCRYPTION='N' */;

use movietickets;

CREATE TABLE `Movie` (
  `movie_id` nvarchar(8),
  `movie_name` nvarchar(50),
  `director` nvarchar(50),
  `duration` int,
  `release_date` Date,
  PRIMARY KEY (`movie_id`)
);

CREATE TABLE `Movie_Screening` (
  `screening_id` nvarchar(8),
  `movie_id` nvarchar(8),
  `cinehouse_id` nvarchar(5),
  `audi_id` nvarchar(5),
  `date and time` time,
  `seats_left` int,
  `price` int,
  PRIMARY KEY (`screening_id`),
  FOREIGN KEY (`price`) REFERENCES `Movie`(`movie_name`)
);

CREATE TABLE `Customer` (
  `customer_id` nvarchar(8),
  `customer_name` nvarchar(50),
  `email` varchar(60),
  `phone` char(10),
  `amount` int,
  PRIMARY KEY (`customer_id`)
);

CREATE TABLE `Reservation` (
  `reservation_id` nvarchar(8),
  `screening_id` nvarchar(8),
  `customer_id` nvarchar(8),
  PRIMARY KEY (`reservation_id`)
);

CREATE TABLE `Cinemahouse` (
  `cinehouse_id` nvarchar(5),
  `cinema_name` nvarchar(20),
  `city` nvarchar(50),
  `funds` int,
  PRIMARY KEY (`cinehouse_id`)
);

CREATE TABLE `Auditorium` (
  `cinehouse_id` nvarchar(5),
  `audi_id` nvarchar(5),
  `capacity` int,
  KEY `Key` (`audi_id`)
);

CREATE TABLE `Seats` (
  `reservation_id` nvarchar(8),
  `seat_id` nvarchar(5),
  KEY `Key` (`seat_id`)
);

