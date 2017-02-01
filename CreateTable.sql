-- Tables

-- Table: Clients
IF OBJECT_ID('dbo.Clients', 'U') IS NOT NULL
DROP TABLE dbo.Clients

CREATE TABLE Clients (
    ClientID int  NOT NULL IDENTITY(1, 1),
    Company bit  NOT NULL,
    CompanyName nvarchar(50)  NULL,
    ClientFirstname nvarchar(30)  NULL,
    ClientLastname nvarchar(50)  NULL,
    Country nvarchar(50)  NOT NULL,
    City nvarchar(50)  NOT NULL,
    Address nvarchar(50)  NOT NULL,
    PostalCode nvarchar(50)  NOT NULL,
    Phone nvarchar(50)  NOT NULL,
    Email nvarchar(50)  NOT NULL,
    Password nvarchar(50)  NOT NULL,
    CONSTRAINT ClientsUnique UNIQUE (Email, Phone),
    CONSTRAINT check1 CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'),
    CONSTRAINT check2 CHECK (Email LIKE '%[@]_%[.]__' OR Email LIKE '%[@]%[.]___' OR Email LIKE '%[@]%[.]____'  ),
    CONSTRAINT ClientsPK PRIMARY KEY  (ClientID)
)
;





-- Table: ConferenceDay
IF OBJECT_ID('dbo.ConferenceDay', 'U') IS NOT NULL
DROP TABLE ConferenceDay

CREATE TABLE ConferenceDay (
    ConferenceDayID int  NOT NULL IDENTITY(1, 1),
    ConferenceID int  NOT NULL,
    Slots int  NOT NULL,
    SlotsLeft int  NOT NULL,
    Date date  NOT NULL,
    CONSTRAINT ConferenceDayUnique UNIQUE (Date),
    CONSTRAINT check8 CHECK (Slots > 0),
    CONSTRAINT check8a CHECK (SlotsLeft >= 0),
    CONSTRAINT ConferenceDayPK PRIMARY KEY  (ConferenceDayID),
    CONSTRAINT badgen2 CHECK (Date > GETDATE())

)
;

CREATE NONCLUSTERED INDEX ConferenceDayIndex1 on ConferenceDay (ConferenceID ASC)
;






-- Table: ConferenceParticipantNotification
IF OBJECT_ID('dbo.ConferenceParticipantNotification', 'U') IS NOT NULL
DROP TABLE ConferenceParticipantNotification

CREATE TABLE ConferenceParticipantNotification (
    ConferenceParticipantNotificationID int  NOT NULL IDENTITY(1, 1),
    ParticipantID int  NOT NULL,
    ConferenceReservationID int  NOT NULL,
    CONSTRAINT ConferenceParticipantsPK PRIMARY KEY  (ConferenceParticipantNotificationID)
)
;

CREATE NONCLUSTERED INDEX ConferenceParticipantNotificationIndex1 on ConferenceParticipantNotification (ConferenceReservationID ASC)
;


CREATE NONCLUSTERED INDEX ConferenceParticipantNotificationIndex2 on ConferenceParticipantNotification (ParticipantID ASC)
;


CREATE NONCLUSTERED INDEX ConferenceParticipantNotificationIndex3 on ConferenceParticipantNotification (ParticipantID ASC,ConferenceReservationID ASC)
;






-- Table: ConferenceReservation
IF OBJECT_ID('dbo.ConferenceReservation', 'U') IS NOT NULL
DROP TABLE ConferenceReservation

CREATE TABLE ConferenceReservation (
    ConferenceReservationID int  NOT NULL IDENTITY(1, 1),
    ClientID int  NOT NULL,
    ConferenceDayID int  NOT NULL,
    ReservationDate date  NOT NULL,
    ReservationSlots int  NOT NULL,
    ReservationStudents int  NOT NULL,
    ReservationPrice money  NOT NULL,
    Canceled bit  NOT NULL DEFAULT 0,
    CONSTRAINT check4 CHECK (ReservationSlots > 0),
    CONSTRAINT check5 CHECK (ReservationPrice >= 0),
    CONSTRAINT check7 CHECK (ReservationStudents >= 0),
	CONSTRAINT badgen1 CHECK (ReservationDate >= GETDATE()),
    CONSTRAINT ConferenceReservationPK PRIMARY KEY  (ConferenceReservationID)
)
;

CREATE NONCLUSTERED INDEX ConferenceReservationIndex1 on ConferenceReservation (ClientID ASC)
;


CREATE NONCLUSTERED INDEX ConferenceReservationIndex2 on ConferenceReservation (ConferenceDayID ASC)
;


CREATE NONCLUSTERED INDEX ConferenceReservationIndex3 on ConferenceReservation (ClientID ASC,ConferenceDayID ASC)
;






-- Table: Conferences
IF OBJECT_ID('dbo.Conferences', 'U') IS NOT NULL
DROP TABLE Conferences

CREATE TABLE Conferences (
    ConferenceID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(50)  NOT NULL,
    Place nvarchar(50)  NOT NULL,
    Description ntext  NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT ConferencesUnique UNIQUE (StartDate, EndDate),
    CONSTRAINT check11 CHECK (StartDate <= EndDate),
    CONSTRAINT ConferencesPK PRIMARY KEY  (ConferenceID),
    CONSTRAINT badgen4 CHECK (StartDate > GETDATE()),
    CONSTRAINT badgen5 CHECK (EndDate > GETDATE())

)
;





-- Table: Participants
IF OBJECT_ID('dbo.Participants', 'U') IS NOT NULL
DROP TABLE Participants

CREATE TABLE Participants (
    ParticipantID int  NOT NULL IDENTITY(1, 1),
    ParticipantFirstname nvarchar(30)  NOT NULL,
    ParticipantLastname nvarchar(50)  NOT NULL,
    Email nvarchar(50)  NOT NULL,
    Password nvarchar(50)  NOT NULL,
    StudentID int  NULL,
    CONSTRAINT ParticipantsUnique UNIQUE (Email, StudentID),
    CONSTRAINT check18 CHECK (Email LIKE '%[@]_%[.]__' OR Email LIKE '%[@]%[.]___' OR Email LIKE '%[@]%[.]____'  ),
    CONSTRAINT ParticipantsPK PRIMARY KEY  (ParticipantID)
)
;





-- Table: Payments
IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL
DROP TABLE Payments

CREATE TABLE Payments (
    PaymentID int  NOT NULL IDENTITY(1, 1),
    ConferenceReservationID int  NOT NULL,
    Amount money  NOT NULL,
    Date date  NOT NULL,
    CONSTRAINT check6 CHECK (Amount >= 0),
    CONSTRAINT PaymentsPK PRIMARY KEY  (PaymentID),
    CONSTRAINT badgen8 CHECK (Date >= GETDATE())

)
;





-- Table: PricesInfo
IF OBJECT_ID('dbo.PricesInfo', 'U') IS NOT NULL
DROP TABLE PricesInfo

CREATE TABLE PricesInfo (
    PricesInfoID int  NOT NULL IDENTITY(1, 1),
    ConferenceDayID int  NOT NULL,
    Expires date  NOT NULL,
    SlotPrice money  NOT NULL,
    StudentDiscount int  NOT NULL,
    CONSTRAINT check9 CHECK (StudentDiscount between 0 and 100),
    CONSTRAINT check10 CHECK (SlotPrice >= 0),
    CONSTRAINT PricesInfoPK PRIMARY KEY  (PricesInfoID),
    CONSTRAINT badgen3 CHECK (Expires >= GETDATE())

)
;

CREATE NONCLUSTERED INDEX PricesInfoIndex1 on PricesInfo (ConferenceDayID ASC)
;






-- Table: WorkshopParticipantNotification
IF OBJECT_ID('dbo.WorkshopParticipantNotification', 'U') IS NOT NULL
DROP TABLE WorkshopParticipantNotification

CREATE TABLE WorkshopParticipantNotification (
    WorkshopParticipantNotificationID int  NOT NULL IDENTITY(1, 1),
    WorkshopReservationID int  NOT NULL,
    ConferenceParticipantNotificationID int  NOT NULL,
    CONSTRAINT WorkshopParticipantsPK PRIMARY KEY  (WorkshopParticipantNotificationID)
)
;

CREATE NONCLUSTERED INDEX WorkshopParticipantNotificationIndex1 on WorkshopParticipantNotification (WorkshopReservationID ASC)
;


CREATE NONCLUSTERED INDEX WorkshopParticipantNotificationIndex2 on WorkshopParticipantNotification (ConferenceParticipantNotificationID ASC)
;






-- Table: WorkshopReservation
IF OBJECT_ID('dbo.WorkshopReservation', 'U') IS NOT NULL
DROP TABLE WorkshopReservation

CREATE TABLE WorkshopReservation (
    WorkshopReservationID int  NOT NULL IDENTITY(1, 1),
    WorkshopID int  NOT NULL,
    ConferenceReservationID int  NOT NULL,
    ReservationSlots int  NOT NULL,
    ReservationPrice money  NOT NULL,
    Canceled bit  NOT NULL DEFAULT 0,
    CONSTRAINT check16 CHECK (ReservationSlots > 0),
    CONSTRAINT check17 CHECK (ReservationPrice >= 0),
    CONSTRAINT WorkshopReservationPK PRIMARY KEY  (WorkshopReservationID)
)
;

CREATE NONCLUSTERED INDEX WorkshopReservationIndex1 on WorkshopReservation (WorkshopID ASC)
;


CREATE NONCLUSTERED INDEX WorkshopReservationIndex2 on WorkshopReservation (ConferenceReservationID ASC)
;


CREATE NONCLUSTERED INDEX WorkshopReservationIndex3 on WorkshopReservation (WorkshopID ASC,ConferenceReservationID ASC)
;






-- Table: Workshops
IF OBJECT_ID('dbo.Workshops', 'U') IS NOT NULL
DROP TABLE Workshops

CREATE TABLE Workshops (
    WorkshopID int  NOT NULL IDENTITY(1, 1),
    ConferenceDayID int  NOT NULL,
    Title nvarchar(50)  NOT NULL,
    Description ntext  NULL,
    Slots int  NOT NULL,
    SlotsLeft int  NOT NULL,
    StartTime datetime  NOT NULL,
    EndTime datetime  NOT NULL,
    SlotPrice money  NOT NULL,
    CONSTRAINT check12 CHECK (Slots > 0),
    CONSTRAINT check13 CHECK (SlotPrice >= 0),
    CONSTRAINT check14 CHECK (StartTime < EndTime),
    CONSTRAINT check15 CHECK (SlotsLeft >= 0),
    CONSTRAINT WorkshopsPK PRIMARY KEY  (WorkshopID),
    CONSTRAINT badgen6 CHECK (StartTime > GETDATE()),
    CONSTRAINT badgen7 CHECK (EndTime > GETDATE())

)
;

CREATE NONCLUSTERED INDEX WorkshopsIndex1 on Workshops (ConferenceDayID ASC)
;





-- Foreign keys

-- Reference:  ConfReservation_ConfDay (table: ConferenceReservation)

ALTER TABLE ConferenceReservation ADD CONSTRAINT ConfReservation_ConfDay 
    FOREIGN KEY (ConferenceDayID)
    REFERENCES ConferenceDay (ConferenceDayID)
;

-- Reference:  ConferenceDay_Conferences (table: ConferenceDay)

ALTER TABLE ConferenceDay ADD CONSTRAINT ConferenceDay_Conferences 
    FOREIGN KEY (ConferenceID)
    REFERENCES Conferences (ConferenceID)
;

-- Reference:  ConferenceParticipants_ConferenceReservation (table: ConferenceParticipantNotification)

ALTER TABLE ConferenceParticipantNotification ADD CONSTRAINT ConferenceParticipants_ConferenceReservation 
    FOREIGN KEY (ConferenceReservationID)
    REFERENCES ConferenceReservation (ConferenceReservationID)
;

-- Reference:  ConferenceParticipants_Participants (table: ConferenceParticipantNotification)

ALTER TABLE ConferenceParticipantNotification ADD CONSTRAINT ConferenceParticipants_Participants 
    FOREIGN KEY (ParticipantID)
    REFERENCES Participants (ParticipantID)
;

-- Reference:  ConferenceReservation_Clients (table: ConferenceReservation)

ALTER TABLE ConferenceReservation ADD CONSTRAINT ConferenceReservation_Clients 
    FOREIGN KEY (ClientID)
    REFERENCES Clients (ClientID)
;

-- Reference:  Payments_ConferenceReservation (table: Payments)

ALTER TABLE Payments ADD CONSTRAINT Payments_ConferenceReservation 
    FOREIGN KEY (ConferenceReservationID)
    REFERENCES ConferenceReservation (ConferenceReservationID)
;

-- Reference:  PricesInfo_ConferenceDay (table: PricesInfo)

ALTER TABLE PricesInfo ADD CONSTRAINT PricesInfo_ConferenceDay 
    FOREIGN KEY (ConferenceDayID)
    REFERENCES ConferenceDay (ConferenceDayID)
;

-- Reference:  WPN_CPN (table: WorkshopParticipantNotification)

ALTER TABLE WorkshopParticipantNotification ADD CONSTRAINT WPN_CPN 
    FOREIGN KEY (ConferenceParticipantNotificationID)
    REFERENCES ConferenceParticipantNotification (ConferenceParticipantNotificationID)
;

-- Reference:  WorkshopParticipants_WorkshopReservation (table: WorkshopParticipantNotification)

ALTER TABLE WorkshopParticipantNotification ADD CONSTRAINT WorkshopParticipants_WorkshopReservation 
    FOREIGN KEY (WorkshopReservationID)
    REFERENCES WorkshopReservation (WorkshopReservationID)
;

-- Reference:  WorkshopReservation_ConferenceReservation (table: WorkshopReservation)

ALTER TABLE WorkshopReservation ADD CONSTRAINT WorkshopReservation_ConferenceReservation 
    FOREIGN KEY (ConferenceReservationID)
    REFERENCES ConferenceReservation (ConferenceReservationID)
;

-- Reference:  WorkshopReservation_Workshops (table: WorkshopReservation)

ALTER TABLE WorkshopReservation ADD CONSTRAINT WorkshopReservation_Workshops 
    FOREIGN KEY (WorkshopID)
    REFERENCES Workshops (WorkshopID)
;

-- Reference:  Workshops_ConferenceDay (table: Workshops)

ALTER TABLE Workshops ADD CONSTRAINT Workshops_ConferenceDay 
    FOREIGN KEY (ConferenceDayID)
    REFERENCES ConferenceDay (ConferenceDayID)
;
