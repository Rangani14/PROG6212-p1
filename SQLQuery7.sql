CREATE TABLE  Routes
(
    RouteID INT IDENTITY(1,1) PRIMARY KEY,

    EventID INT NOT NULL,

    DistanceKm DECIMAL(6,2) NOT NULL,

    Description NVARCHAR(500) NULL,

    MapUrl NVARCHAR(500) NULL,

    CONSTRAINT FK_Routes_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Routes_Distance
        CHECK (DistanceKm > 0)
);

GO