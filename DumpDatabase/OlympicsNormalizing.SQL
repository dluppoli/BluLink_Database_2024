USE Olympics;

DROP table IF EXISTS Partecipations;
DROP table IF EXISTS Medals;
DROP table IF EXISTS AthletesNF;
DROP table IF EXISTS Games;
DROP table IF EXISTS Events;



create table AthletesNF(
    IdAthlete INT PRIMARY KEY,
    Name VARCHAR(1024) NOT NULL,
    Sex CHAR(1) NOT NULL,
    Height SMALLINT,
    Weight SMALLINT
);

create table Games(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Games VARCHAR(1024) NOT NULL,
    Year SMALLINT NOT NULL,
    Season VARCHAR(1024) NOT NULL
);

create table Events(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Event Varchar(1024) NOT NULL,
    Sport Varchar(1024) NOT NULL
);

create table Partecipations(
    Id INT PRIMARY KEY IDENTITY(1,1),
    IdAthlete INT NOT NULL,
    Age SMALLINT,
    NOC CHAR(3),
    IdGame INT NOT NULL,
    City VARCHAR(1024) NOT NULL,
    IdEvent INT NOT NULL,
    FOREIGN KEY(IdAthlete) REFERENCES AthletesNF(IdAthlete),
    FOREIGN KEY(IdGame) REFERENCES Games(Id),
    FOREIGN KEY(IdEvent) REFERENCES Events(Id)
);

create table Medals(
    IdAthlete INT,
    IdGame INT,
    IdEvent INT,
    Medal varchar(10),
    PRIMARY KEY(IdAthlete,IdGame,IdEvent,Medal),
    FOREIGN KEY(IdAthlete) REFERENCES AthletesNF(IdAthlete),
    FOREIGN KEY(IdGame) REFERENCES Games(Id),
    FOREIGN KEY(IdEvent) REFERENCES Events(Id)
);

INSERT INTO Events(Event,Sport)
SELECT DISTINCT Event,Sport FROM Athletes;

INSERT INTO Games(Games, Year, Season)
SELECT DISTINCT Games, Year, Season FROM Athletes;

INSERT INTO AthletesNF(IdAthlete, Name, Sex, Height, Weight)
SELECT DISTINCT IdAthlete, Name, Sex, Height, Weight FROM Athletes;

INSERT INTO Partecipations(IdAthlete, Age, NOC, IdGame, City, IdEvent)
SELECT DISTINCT A.IdAthlete, A.Age, A.NOC, G.Id AS IdGame, A.City, E.Id As IdEvent
FROM Athletes A INNER JOIN Games G On A.Games = G.Games AND A.Year=G.Year AND A.Season = G.Season
INNER JOIN Events E On A.Sport = E.Sport AND A.Event = E.Event;

INSERT INTO  Medals(IdAthlete, IdGame, IdEvent, Medal)
SELECT DISTINCT A.IdAthlete, G.Id As IdGame, E.Id AS IdEvent, A.Medal
FROM Athletes A INNER JOIN Games G On A.Games = G.Games AND A.Year=G.Year AND A.Season = G.Season
INNER JOIN Events E On A.Sport = E.Sport AND A.Event = E.Event
WHERE A.Medal IS NOT NULL

