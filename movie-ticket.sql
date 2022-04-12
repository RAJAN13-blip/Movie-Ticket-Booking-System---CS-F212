drop database movietickets;

CREATE DATABASE movietickets /*!40100 DEFAULT CHARACTER SET
utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT
ENCRYPTION='N' */;

use movietickets;

CREATE TABLE `Customer` (
  `customer_id` nvarchar(8),
  `customer_name` nvarchar(50),
  `email` varchar(60),
  `phone` char(10),
  `amount`  int unsigned,
  PRIMARY KEY (`customer_id`)
);

CREATE TABLE `Movie` (
  `movie_id` nvarchar(8),
  `movie_name` longtext,
  `director` nvarchar(50),
  `duration`  int unsigned,
  `release_date` Date,
  PRIMARY KEY (`movie_id`)
);

CREATE TABLE `Cinemahouse` (
  `cinehouse_id` nvarchar(5),
  `cinema_name` nvarchar(20),
  `city` nvarchar(50),
  `funds` int unsigned,
  PRIMARY KEY (`cinehouse_id`)
);

CREATE TABLE `Auditorium` (
  `cinehouse_id` nvarchar(5),
  `audi_id` nvarchar(5),
  `capacity` int unsigned,
  foreign key (`cinehouse_id`) references `Cinemahouse`(`cinehouse_id`) on delete cascade,
  KEY `Key` (`audi_id`)
);

CREATE TABLE `Movie_Screening` (
  `screening_id` nvarchar(8),
  `movie_id` nvarchar(8),
  `cinehouse_id` nvarchar(5),
  `audi_id` nvarchar(5),
  `date and time` datetime,
  `seats_left` int unsigned,
  `price` int unsigned,
  PRIMARY KEY (`screening_id`),
  FOREIGN KEY (`movie_id`) REFERENCES `Movie`(`movie_id`) on delete cascade,
  FOREIGN KEY (`cinehouse_id`) REFERENCES `Cinemahouse`(`cinehouse_id`) on delete cascade,
  FOREIGN KEY (`audi_id`) REFERENCES `Auditorium`(`audi_id`) on delete cascade
);

CREATE TABLE `Reservation` (
  `reservation_id` nvarchar(8),
  `screening_id` nvarchar(8),
  `customer_id` nvarchar(8),
  PRIMARY KEY (`reservation_id`),
  FOREIGN KEY (`screening_id`) REFERENCES `Movie_Screening`(`screening_id`) on delete cascade,
  FOREIGN KEY (`customer_id`) REFERENCES `Customer`(`customer_id`) on delete cascade
);

CREATE TABLE `Seats` (
  `reservation_id` nvarchar(8),
  `seat_id` int unsigned,
   KEY (`seat_id`),
  foreign key (`reservation_id`) references `Reservation`(`reservation_id`)
);



-- Customer Insertion
INSERT into Customer values ('1','Hrithik','hrithikgupt@gmail.com','7017937265',500);
INSERT into Customer values ('2','Rajan','rajansahu10@gmail.com','9938971081',300);
-- Movie Insertion
INSERT into Movie values ('1','RRR','SS Rajamouli','120','2022-04-01');
INSERT into Movie values ('2','Kashmir Files','Vivek Agnihotri','125','2022-03-01');
-- Cinemahouse Insertion
INSERT into Cinemahouse values ('1','INOX','Delhi',0);
-- INSERT into Cinemahouse values ('2','INOX','Pilani',0);
-- Auditorium Insertion
INSERT into Auditorium values ('1','1',10);
-- INSERT into Auditorium values ('1','2',10);
-- INSERT into Auditorium values ('2','1',10);
-- Movie_Screening Insertion
INSERT into Movie_Screening values ('1','1','1','1','2022-04-15 15:00:00',10,100);
INSERT into Movie_Screening values ('2','1','1','1','2022-04-15 20:00:00',10,100);
INSERT into Movie_Screening values ('3','2','1','1','2022-04-15 10:00:00',10,100);
-- INSERT into Movie_Screening values ('4','2','2','1','2022-04-15 15:00:00',10,100);
-- INSERT into Movie_Screening values ('5','1','1','2','2022-04-15 20:00:00',10,100);
-- INSERT into Movie_Screening values ('6','2','1','2','2022-04-15 10:00:00',10,100);
-- Seats Insertion
INSERT into Seats values 
(NULL,1),
(NULL,2),
(NULL,3),
(NULL,4),
(NULL,5),
(NULL,6),
(NULL,7),
(NULL,8),
(NULL,9),
(NULL,10);



