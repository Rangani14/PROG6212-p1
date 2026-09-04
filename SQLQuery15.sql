SELECT *
FROM Users;
-- Display all events and their organisers
SELECT
    E.EventID,
    E.Name AS EventName,
    E.EventDate,
    E.Location,
    U.FirstName + ' ' + U.LastName AS Organiser
FROM Events E
INNER JOIN Users U
    ON E.OrganiserID = U.UserID;

SELECT
    E.Name AS EventName,
    C.Name AS Category,
    C.DistanceKm,
    C.MaxParticipants,
    C.EntryFee
FROM Categories C
INNER JOIN Events E
    ON C.EventID = E.EventID
ORDER BY E.Name;

-- Display enrolments
SELECT
    U.FirstName + ' ' + U.LastName AS Participant,
    E.Name AS EventName,
    C.Name AS Category,
    EN.EnrolmentDate,
    EN.Status
FROM Enrolments EN
INNER JOIN Users U
    ON EN.ParticipantID = U.UserID
INNER JOIN Categories C
    ON EN.CategoryID = C.CategoryID
INNER JOIN Events E
    ON C.EventID = E.EventID;

-- Display results
SELECT
    U.FirstName + ' ' + U.LastName AS Participant,
    E.Name AS EventName,
    C.Name AS Category,
    R.FinishTime,
    R.Position,
    R.ResultStatus
FROM Results R
INNER JOIN Enrolments EN
    ON R.EnrolmentID = EN.EnrolmentID
INNER JOIN Users U
    ON EN.ParticipantID = U.UserID
INNER JOIN Categories C
    ON EN.CategoryID = C.CategoryID
INNER JOIN Events E
    ON C.EventID = E.EventID;

GO