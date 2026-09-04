CREATE DATABASE RaceDayDB;
USE RaceDayDB;

CREATE TABLE Organisers (
    OrganiserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Participants (
    ParticipantID INT IDENTITY (1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);


CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    Name VARCHAR(150) NOT NULL,
    Description VARCHAR(1000) NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(150) NOT NULL,
    Distance DECIMAL(6,2) NULL,
    ElevationGain DECIMAL(6,2) NULL,
    StartPoint VARCHAR(150) NULL,
    EndPoint VARCHAR(150) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserID) REFERENCES Organisers(OrganiserID)
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EntryFee DECIMAL(8,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

CREATE TABLE EventEnrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_Enrolments_ParticipantCategory UNIQUE (ParticipantID, CategoryID)
);

CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL,
    FinishTime TIME NOT NULL,
    Position INT NULL,
    CapturedBy INT NULL,
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentID) REFERENCES EventEnrolments(EnrolmentID),
    CONSTRAINT FK_Results_CapturedBy FOREIGN KEY (CapturedBy) REFERENCES Organisers(OrganiserID),
    CONSTRAINT UQ_Results_Enrolment UNIQUE (EnrolmentID)
);

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL,
    Amount DECIMAL(8,2) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Paid', 'Failed')),
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentMethod VARCHAR(50) NULL,
    CONSTRAINT FK_Payments_Enrolment FOREIGN KEY (EnrolmentID) REFERENCES EventEnrolments(EnrolmentID),
    CONSTRAINT UQ_Payments_Enrolment UNIQUE (EnrolmentID)
);

-- ========== SEED DATA ==========

INSERT INTO Organisers (FullName, Email, PasswordHash, PhoneNumber)
VALUES
('Thabo Mokoena', 'thabo.mokoena@raceday.co.za', 'HASHED_PASSWORD_1', '0821234567'),
('Lindiwe Nkosi', 'lindiwe.nkosi@raceday.co.za', 'HASHED_PASSWORD_2', '0837654321');

INSERT INTO Participants (FullName, Email, PasswordHash, PhoneNumber)
VALUES
('Sipho Dlamini', 'sipho.dlamini@gmail.com', 'HASHED_PASSWORD_3', '0741234567'),
('Anelisa Botha', 'anelisa.botha@gmail.com', 'HASHED_PASSWORD_4', '0769876543');

INSERT INTO Events (OrganiserID, Name, Description, EventDate, Location, Distance, ElevationGain, StartPoint, EndPoint)
VALUES
(1, 'Johannesburg City Run', 'Annual road running event through the Johannesburg CBD.', '2026-11-15', 'Johannesburg, Gauteng', 21.10, 180.5, 'Constitution Hill', 'Ellis Park Stadium'),
(1, 'Soweto Community Marathon', 'Community marathon celebrating Soweto''s running heritage.', '2026-10-04', 'Soweto, Gauteng', 42.20, 320.0, 'Orlando Stadium', 'Orlando Stadium'),
(2, 'Cape Winelands Cycle Tour', 'Scenic cycling tour through the Cape Winelands.', '2027-03-08', 'Stellenbosch, Western Cape', 94.70, 950.0, 'Stellenbosch Town Square', 'Franschhoek Square');

INSERT INTO Categories (EventID, Name, Distance, EntryFee)
VALUES
(1, '5km Fun Run', 5.00, 100.00),
(1, '21km Half Marathon', 21.10, 250.00),
(2, '10km Run', 10.00, 150.00),
(2, '42km Marathon', 42.20, 350.00),
(3, '50km Cycle', 50.00, 300.00),
(3, '94km Cycle', 94.70, 450.00);

INSERT INTO EventEnrolments (ParticipantID, CategoryID)
VALUES
(1, 2),
(2, 3),
(1, 5);

INSERT INTO Payments (EnrolmentID, Amount, PaymentStatus, PaymentMethod)
VALUES
(1, 250.00, 'Paid', 'Card'),
(2, 150.00, 'Paid', 'EFT'),
(3, 300.00, 'Pending', NULL);

INSERT INTO Results (EnrolmentID, FinishTime, Position, CapturedBy)
VALUES
(1, '01:45:32', 12, 1);