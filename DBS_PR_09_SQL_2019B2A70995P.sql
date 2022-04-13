-- drop database movietickets;
-- Database Creation 
CREATE DATABASE movietickets /*!40100 DEFAULT CHARACTER SET
utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT
ENCRYPTION='N' */;

use movietickets;


-- Table Creation
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
  `reservation_id` int unsigned auto_increment,
  `screening_id` nvarchar(8),
  `customer_id` nvarchar(8),
  PRIMARY KEY (`reservation_id`),
  FOREIGN KEY (`screening_id`) REFERENCES `Movie_Screening`(`screening_id`) on delete cascade,
  FOREIGN KEY (`customer_id`) REFERENCES `Customer`(`customer_id`) on delete cascade
);

ALTER TABLE Reservation auto_increment=1;

CREATE TABLE `Seats` (
  `seat_id` int unsigned,
  `reservation_id` int unsigned,
   primary key (`seat_id`,`reservation_id`),
  foreign key (`reservation_id`) references `Reservation`(`reservation_id`) on delete cascade
);

-- Data Insertion
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

-- Procedures and Functions
-- drop function reserved_seats;
-- seats reserved list
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION
`reserved_seats`(reservation_id nvarchar(8)) RETURNS varchar(3) CHARSET
utf8mb4
 DETERMINISTIC
BEGIN
 DECLARE sf_value VARCHAR(3);
 IF reservation_id is not null
 THEN SET sf_value = 'Yes';
 ELSEIF reservation_id is null
 THEN SET sf_value = 'No';
 END IF;
 RETURN sf_value;
 END$$
DELIMITER ;

-- drop procedure movies_filter;
-- filters out movie shows by movie names
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE
`movies_filter`(IN movi_name longtext)
 READS SQL DATA
 DETERMINISTIC
 SQL SECURITY INVOKER
 COMMENT 'Movie wise filtered list of shows, Input -
movie name and Output – shows'
BEGIN
select screening_id, movie_name, audi_id, `date and time` ,seats_left, cinema_name, city 
from movie_screening, movie,cinemahouse 
where movie.movie_id=movie_screening.movie_id and movie.movie_name = movi_name
and movie_screening.cinehouse_id = cinemahouse.cinehouse_id;
END$$
DELIMITER ;

-- drop procedure seats_reserved;
-- filters out the seats that are available for particular screening
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE
`seats_reserved`(IN screening_id nvarchar(8))
 READS SQL DATA
 DETERMINISTIC
 SQL SECURITY INVOKER
 COMMENT 'Check for seats reserved in a particular screening'
BEGIN
select seats.seat_id, reserved_seats(seats.reservation_id) as 'Is Reserved' from movietickets.seats where seats.reservation_id in (select reservation.reservation_id from movietickets.reservation
	where reservation.screening_id=screening_id);
END$$
DELIMITER ;

-- drop procedure view_reservations;
-- filters out the reservations under current customer_id
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE
`view_reservations`(IN customer_id nvarchar(8))
 READS SQL DATA
 DETERMINISTIC
 SQL SECURITY INVOKER
 COMMENT 'View seat reservations under customer_id'
BEGIN
create table t1 as select screening_id,reservation_id from reservation where reservation.customer_id = customer_id;
create table t2 as select screening_id, t1.reservation_id, seat_id from t1, seats where seats.reservation_id = t1.reservation_id;
create table t3 as select movie_name, t2.screening_id,cinehouse_id,audi_id,`date and time`,seat_id from movie_screening, movie,t2 where movie_screening.movie_id = movie.movie_id and t2.screening_id = movie_screening.screening_id;
select * from t3;
drop table t1;
drop table t2;
drop table t3;
END$$
DELIMITER ;


-- drop procedure book_seat;
-- book a seat depending upon availability
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_seat`(IN seat_id int unsigned,IN screening_id nvarchar(8),IN customer_id nvarchar(8))
MODIFIES SQL DATA
NOT DETERMINISTIC
SQL SECURITY INVOKER
COMMENT 'Executes transaction for booking the seats'
BEGIN
DECLARE seatsLeft int unsigned;
DECLARE countSeats int unsigned;
DECLARE ticketPrice int unsigned;
DECLARE cineID nvarchar(5);
DECLARE reserID int unsigned;
DECLARE custAmt int unsigned;
SET seatsLeft=(SELECT Movie_Screening.seats_left from movietickets.Movie_Screening
where Movie_Screening.screening_id=screening_id);
IF seatsLeft > 0 THEN
	CREATE table r_ids as (select reservation.reservation_id from movietickets.reservation
	where reservation.screening_id=screening_id);
	SET countSeats=(select count(seats.seat_id) from r_ids, movietickets.seats
	where r_ids.reservation_id = seats.reservation_id and seats.seat_id=seat_id);
	drop table r_ids;
		IF countSeats = 0 then
			SET ticketPrice=(select Movie_Screening.price from movietickets.Movie_Screening
			where Movie_Screening.screening_id=screening_id);
            SET custAmt=(select customer.amount from movietickets.customer where customer.customer_id=customer_id);
            IF custAmt >= ticketPrice then
			START TRANSACTION;
            update movietickets.movie_screening 
            set movie_screening.seats_left = movie_screening.seats_left - 1 where movie_screening.screening_id = screening_id;
			update movietickets.customer
			set customer.amount = customer.amount - ticketPrice
			where customer.customer_id=customer_id;
	
		
			SET cineID=(select Movie_Screening.cinehouse_id from movietickets.movie_screening where movie_screening.screening_id=screening_id);
            
			update movietickets.cinemahouse
			set cinemahouse.funds = cinemahouse.funds + ticketPrice
			where cinemahouse.cinehouse_id=cineID;
			insert into movietickets.reservation (reservation.screening_id,reservation.customer_id) values(screening_id,customer_id);
			SET reserID=last_insert_id();
			insert into movietickets.seats values(seat_id,reserID);
            select reserID as 'Reservation ID';
			commit;
            ELSE SELECT "Not enough funds" as message;
            END IF;
		ELSE SELECT "Seat already booked" as Message;
		END IF;
ELSE SELECT "No Seats Left" as Message;
END IF;
END$$
DELIMITER ;

-- drop procedure cancel_seat;
-- cancellation of tickets
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_seat`(IN reservation_id int unsigned,IN customer_id nvarchar(8))
MODIFIES SQL DATA
NOT DETERMINISTIC
SQL SECURITY INVOKER
COMMENT 'Executes transaction for canceling the booking of seat'
BEGIN
DECLARE ticketPrice int unsigned;
DECLARE cineID nvarchar(5);
DECLARE reserIDCount int unsigned;
DECLARE custID nvarchar(8);
DECLARE movieDATETIME datetime;
DECLARE screenID nvarchar(8);
SET reserIDCount=(select count(*) from movietickets.reservation where reservation.reservation_id=reservation_id);
IF reserIDCount>0 then
	SET custID=(select reservation.customer_id from movietickets.reservation where reservation.reservation_id=reservation_id);
	IF custID=customer_id then
		SET screenID=(select re.screening_id from movietickets.reservation as re where re.reservation_id=reservation_id);
        SET movieDATETIME=(select ms.`date and time` from movietickets.movie_screening as ms where ms.screening_id=screenID);
		IF movieDATETIME >= now() then
        START TRANSACTION;
        update movietickets.movie_screening 
		set movie_screening.seats_left = movie_screening.seats_left + 1 where movie_screening.screening_id = screenID;
        DELETE from movietickets.reservation where reservation.reservation_id=reservation_id;
        SET ticketPrice=(select Movie_Screening.price from movietickets.Movie_Screening
			where Movie_Screening.screening_id=screenID);
		update movietickets.customer
			set customer.amount = customer.amount + ticketPrice
			where customer.customer_id=customer_id;
		SET cineID=(select Movie_Screening.cinehouse_id from movietickets.movie_screening where movie_screening.screening_id=screenID);
			update movietickets.cinemahouse
			set cinemahouse.funds = cinemahouse.funds - ticketPrice
			where cinemahouse.cinehouse_id=cineID;
        ELSE select "Movie already started. Cannot cancel now" as message;
        END IF;
    ELSE select "Invaild customer_id" as message;
    END IF;
ELSE select "Not a vaild reservation_id" as message;
END IF;
END$$
DELIMITER ;


-- Data Retrival Queries
-- customer database
select * from customer;
-- movie database 
select * from movie;
-- select * from movie_screening;

-- movie shows
-- movie screenings with complete address
call movies_filter('RRR');
call movies_filter('Kashmir Files');
-- filter out by movie names use the view created above 

-- display all the current cinemahouses
select cinema_name,city from cinemahouse;

-- display  seats and reservation
-- seat reservation view 
select seats.seat_id, reserved_seats(seats.reservation_id) as 'Is Reserved' from movietickets.seats;

-- display all the movie shows available 
select screening_id, movie_name, audi_id, `date and time` ,seats_left, cinema_name, city 
from movie_screening, movie,cinemahouse 
where movie.movie_id=movie_screening.movie_id
and movie_screening.cinehouse_id = cinemahouse.cinehouse_id;

-- Booking Seat
call book_seat(1,'1','1'); -- seat_id, screening_id , customer_id
CALL book_seat(2,'1','1'); 
call book_Seat(3,'1','2');
call book_Seat(1,'2','2');
call book_Seat(1,'3','2');

-- Viewing reservation
call view_reservations('2'); -- customer_id
-- call view_reservations('1');

-- Canceling seat
call cancel_seat(1,'1');

-- drop database movietickets;