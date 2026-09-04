CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,

    EnrolmentID INT NOT NULL UNIQUE,

    FinishTime TIME NULL,

    Position INT NULL,

    ResultStatus NVARCHAR(20) NOT NULL
        DEFAULT 'Finished',

    RecordedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Results_Enrolment
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Results_Position
        CHECK (Position IS NULL OR Position > 0),

    CONSTRAINT CK_Results_Status
        CHECK
        (
            ResultStatus IN
            (
                'Finished',
                'Did Not Finish',
                'Disqualified'
            )
        )
);

GO
