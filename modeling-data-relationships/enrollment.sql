DROP TABLE IF EXISTS Student;

DROP TABLE IF EXISTS Class;

DROP TABLE IF EXISTS Enroll;


CREATE TABLE Student(
    StudentID SMALLINT, 
    FirstName VARCHAR(50), 
    LastName VARCHAR(50)
);

CREATE TABLE Class(
    ClassID SMALLINT,
    Name VARCHAR(100)
);

CREATE TABLE Enroll(
    StudentID SMALLINT,
    ClassID SMALLINT,
    Grade VARCHAR(2)
);

INSERT INTO Student (StudentID, FirstName, LastName)
VALUES
    (1, 'Bob', 'Anderson'),
    (2, 'Carol', 'Bendix'),
    (3, 'Donald', 'Carver'),
    (4, 'Elizabeth', 'Danvers'),
    (5, 'Freddy', 'Einhorn');
    
INSERT INTO Class (ClassID, Name)
VALUES
    (1, 'Intro to Wood Carving'),
    (2, 'Advanced Tic Tac Toe'),
    (3, 'Intermediate Paper Airplanes'),
    (4, 'History of Onions'),
    (5, 'Intro to Origami');
    
INSERT INTO Enroll (StudentID, ClassID, Grade)
VALUES
    (1, 1, 'A+'),
    (1, 2, 'B-'),
    (1, 3, 'C+'),
    (2, 1, 'A+'),
    (2, 3, 'B-'),
    (2, 4, 'C+'),
    (3, 1, 'B'),
    (3, 3, 'C'),
    (3, 4, 'C+');