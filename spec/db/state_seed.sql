CREATE TABLE states(
  id SERIAL,
  name TEXT,
  rank INTEGER,
  density_per_square_mile INTEGER
);

INSERT INTO states (name, rank, density_per_square_mile) VALUES
('New Jersey', 1, 1210.1),
('Rhode Island', 2, 1017.1),
('Massachusetts', 3, 858.0),
('Connecticut', 4, 742.6),
('Maryland', 5, 610.8),
('Delaware', 6, 475.1),
('New York', 7, 417.0),
('Florida', 8, 364.6),
('Pennsylvania', 9, 285.5),
('Ohio', 10, 283.2)
