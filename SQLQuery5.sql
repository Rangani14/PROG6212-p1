CREATE TABLE  Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,

    OrganiserID INT NOT NULL,

    Name NVARCHAR(150) NOT NULL,

    Description NVARCHAR(500) NULL,

    EventDate DATE NOT NULL,

    Location NVARCHAR(200) NOT NULL,

    Status NVARCHAR(20) NOT NULL
        DEFAULT 'Upcoming',

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_Status
        CHECK
        (
            Status IN
            (
                'Upcoming',
                'Open',
                'Completed',
                'Cancelled'
            )
        )
);

GO