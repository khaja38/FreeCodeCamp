--
-- PostgreSQL database dump
--

DROP DATABASE IF EXISTS worldcup;
CREATE DATABASE worldcup;
\connect worldcup

--
-- Table structure for table teams
--

CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE
);

--
-- Table structure for table games
--

CREATE TABLE games (
    game_id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    round VARCHAR NOT NULL,
    winner_id INT NOT NULL,
    opponent_id INT NOT NULL,
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL,
    FOREIGN KEY (winner_id) REFERENCES teams(team_id),
    FOREIGN KEY (opponent_id) REFERENCES teams(team_id)
);

--
-- Data for table teams
--

INSERT INTO teams (team_id, name) VALUES
(1,'France'),
(2,'Croatia'),
(3,'Belgium'),
(4,'England'),
(5,'Russia'),
(6,'Sweden'),
(7,'Brazil'),
(8,'Uruguay'),
(9,'Colombia'),
(10,'Switzerland'),
(11,'Japan'),
(12,'Mexico'),
(13,'Denmark'),
(14,'Spain'),
(15,'Portugal'),
(16,'Argentina'),
(17,'Germany'),
(18,'Netherlands'),
(19,'Costa Rica'),
(20,'Chile'),
(21,'Nigeria'),
(22,'Algeria'),
(23,'Greece'),
(24,'United States');

--
-- Data for table games
--

INSERT INTO games (game_id, year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES
(1,2018,'Final',1,2,4,2),
(2,2018,'Third Place',3,4,2,0),
(3,2018,'Semi-Final',2,4,2,1),
(4,2018,'Semi-Final',1,3,1,0),
(5,2018,'Quarter-Final',2,5,3,2),
(6,2018,'Quarter-Final',4,6,2,0),
(7,2018,'Quarter-Final',3,7,2,1),
(8,2018,'Quarter-Final',1,8,2,0),
(9,2018,'Eighth-Final',4,9,2,1),
(10,2018,'Eighth-Final',6,10,1,0),
(11,2018,'Eighth-Final',3,11,3,2),
(12,2018,'Eighth-Final',7,12,2,0),
(13,2018,'Eighth-Final',2,13,2,1),
(14,2018,'Eighth-Final',5,14,2,1),
(15,2018,'Eighth-Final',8,15,2,1),
(16,2018,'Eighth-Final',1,16,4,3),
(17,2014,'Final',17,16,1,0),
(18,2014,'Third Place',18,7,3,0),
(19,2014,'Semi-Final',16,18,1,0),
(20,2014,'Semi-Final',17,7,7,1),
(21,2014,'Quarter-Final',18,19,1,0),
(22,2014,'Quarter-Final',16,3,1,0),
(23,2014,'Quarter-Final',7,9,2,1),
(24,2014,'Quarter-Final',17,1,1,0),
(25,2014,'Eighth-Final',7,20,2,1),
(26,2014,'Eighth-Final',9,8,2,0),
(27,2014,'Eighth-Final',1,21,2,0),
(28,2014,'Eighth-Final',17,22,2,1),
(29,2014,'Eighth-Final',18,12,2,1),
(30,2014,'Eighth-Final',19,23,2,1),
(31,2014,'Eighth-Final',16,10,1,0),
(32,2014,'Eighth-Final',3,24,2,1);
