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



