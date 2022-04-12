use movietickets;

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

