INSERT INTO Events
(
    OrganiserID,
    Name,
    Description,
    EventDate,
    Location,
    Status
)
VALUES
(
    1,
    'Johannesburg City Run',
    'Annual road running event through Johannesburg.',
    '2026-10-18',
    'Johannesburg, Gauteng',
    'Open'
),
(
    1,
    'Cape Town Coastal Cycle',
    'Cycling event along the Cape Town coastline.',
    '2026-11-08',
    'Cape Town, Western Cape',
    'Upcoming'
),
(
    2,
    'Durban Beach Walk',
    'Community walking event along the Durban beachfront.',
    '2026-12-05',
    'Durban, KwaZulu-Natal',
    'Upcoming'
);

GO

/* ============================================================
   INSERT CATEGORIES
   Categories for every event.
   ============================================================ */

INSERT INTO Categories
(
    EventID,
    Name,
    DistanceKm,
    MaxParticipants,
    EntryFee
)
VALUES
(
    1,
    '5 KM Fun Run',
    5.00,
    1000,
    100.00
),
(
    1,
    '10 KM Road Race',
    10.00,
    1500,
    180.00
),
(
    1,
    '21 KM Half Marathon',
    21.10,
    2000,
    300.00
),
(
    2,
    '20 KM Cycle',
    20.00,
    500,
    200.00
),
(
    2,
    '50 KM Cycle',
    50.00,
    750,
    350.00
),
(
    3,
    '5 KM Beach Walk',
    5.00,
    800,
    80.00
),
(
    3,
    '10 KM Beach Walk',
    10.00,
    1000,
    120.00
);

GO
