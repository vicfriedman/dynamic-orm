CREATE TABLE programmers (
  id SERIAL,
  name TEXT,
  language TEXT
);

INSERT INTO programmers (name, language) VALUES
('Yukihiro Matzumoto', 'Ruby'),
('Alan Kay', 'Smalltalk'),
('Dennis Ritchie', 'C')
