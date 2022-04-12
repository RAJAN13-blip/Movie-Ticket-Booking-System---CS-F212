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

-- drop procedure check_seats;
-- filters out the seats that are available for particular screening


-- drop procedure book_seat;
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
SET seatsLeft=(SELECT Movie_Screening.seats_left from movietickets.Movie_Screening
where Movie_Screening.screening_id=screening_id);
IF seatsLeft > 0 THEN
CREATE table r_ids as (select reservation.reservation_id from movietickets.reservation
where reservation.screening_id=screening_id);
SET countSeats=(select count(seats.seat_id) from r_ids, movietickets.seats
where r_ids.reservation_id = seats.reservation_id and seats.seat_id=seat_id);
drop table r_ids;
IF countSeats = 0 then
START TRANSACTION;
SET ticketPrice=(select Movie_Screening.price from movietickets.Movie_Screening
where Movie_Screening.screening_id=screening_id);
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
commit;
ELSE SELECT "Seat already booked" as Message;
END IF;
ELSE SELECT "No Seats Left" as Message;
END IF;
END$$
DELIMITER ;

-- CALL book_seat(1,'1','1');


