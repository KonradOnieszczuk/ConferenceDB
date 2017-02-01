USE master
IF DB_ID('Konferencje_Onieszczuk') IS NOT NULL
DROP DATABASE Konferencje_Onieszczuk
GO
CREATE DATABASE Konferencje_Onieszczuk
GO
USE Konferencje_Onieszczuk
GO


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



--procedures
IF OBJECT_ID('dbo.AddClientCompany') IS NOT NULL
DROP PROC dbo.AddClientCompany
GO

create procedure AddClientCompany
	@CompanyName nvarchar(50),
	@Country nvarchar(50),
	@City nvarchar(50),
	@Address nvarchar(50),
	@PostalCode nvarchar(50),
	@Phone nvarchar(50),
	@Email nvarchar(50),
	@Password nvarchar(50)
	as
	begin
		insert into Clients (Company, CompanyName, ClientFirstname, ClientLastname,
		Country, City, Address, PostalCode, Phone, Email, Password)
		values ('true', @CompanyName, NULL, NULL, @Country, @City, @Address, @PostalCode,
		 @Phone, @Email, @Password)
	end
go



IF OBJECT_ID('dbo.AddClientPrivate') IS NOT NULL
DROP PROC dbo.AddClientPrivate
GO

create procedure AddClientPrivate
	@ClientFirstname nvarchar(50),
	@ClientLastname nvarchar(50),
	@Country nvarchar(50),
	@City nvarchar(50),
	@Address nvarchar(50),
	@PostalCode nvarchar(50),
	@Phone nvarchar(50),
	@Email nvarchar(50),
	@Password nvarchar(50)
	as
	begin
		insert into Clients (Company, CompanyName, ClientFirstname, ClientLastname, Country, City, Address, PostalCode, Phone, Email, Password)
		values ('false', NULL, @ClientFirstname, @ClientLastname, @Country, @City, @Address, @PostalCode, @Phone, @Email, @Password)
	end
go



IF OBJECT_ID('dbo.AddParticipant') IS NOT NULL
DROP PROC dbo.AddParticipant
GO

create procedure AddParticipant
	@Firstname nvarchar(50),
	@Lastname nvarchar(50),
	@Email nvarchar(50),
	@Password nvarchar(50),
	@StudentID int 
	as
	begin
		if (@StudentID <> 0)
			insert into Participants (ParticipantFirstname, ParticipantLastname, Email, Password, StudentID)
			values (@Firstname, @Lastname, @Email, @Password, @StudentID)
		else
			insert into Participants (ParticipantFirstname, ParticipantLastname, Email, Password, StudentID)
			values (@Firstname, @Lastname, @Email, @Password, NULL)
	end
go



IF OBJECT_ID('dbo.AddConference') IS NOT NULL
DROP PROC dbo.AddConference
GO

create procedure AddConference
	@Name nvarchar(50),
	@Place nvarchar(50),
	@Description ntext,
	@StartDate date,
	@EndDate date
	as
	begin
		if (@Description not like '0')
		begin
			insert into Conferences (Name, Place, Description, StartDate, EndDate)
			values (@Name, @Place, @Description, @StartDate, @EndDate)
		end
		else
		begin
			insert into Conferences (Name, Place, Description, StartDate, EndDate)
			values (@Name, @Place, NULL, @StartDate, @EndDate)
		end
	end
go



IF OBJECT_ID('dbo.AddConferenceDay') IS NOT NULL
DROP PROC dbo.AddConferenceDay
GO

create procedure AddConferenceDay
	@ConferenceID int,
	@Slots int,
	@Date date
	as
	begin
if (@Date between (select StartDate from Conferences where ConferenceID = @ConferenceID) and (select EndDate from Conferences where ConferenceID = @ConferenceID)) 
		begin
			insert into ConferenceDay (ConferenceID, Slots, SlotsLeft, Date)
			values (@ConferenceID, @Slots, @Slots, @Date)
		end
		else
		begin
			THROW 51000, 'Wrong data', 1
		end
	end
go



IF OBJECT_ID('dbo.AddPricesInfo') IS NOT NULL
DROP PROC dbo.AddPricesInfo
GO

create procedure AddPricesInfo
	@ConferenceDayID int,
	@Expires date,
	@SlotPrice money,
	@StudentDiscount int
	as
	begin
		insert into PricesInfo (ConferenceDayID, Expires, SlotPrice, StudentDiscount)
		values (@ConferenceDayID, @Expires, @SlotPrice, @StudentDiscount)
	end
go


IF OBJECT_ID('dbo.AddWorkshop') IS NOT NULL
DROP PROC dbo.AddWorkshop
GO

create procedure AddWorkshop
	@ConferenceDayID nvarchar(50),
	@Title nvarchar(50),
	@Description ntext,
	@Slots int,
	@StartTime datetime,
	@EndTime datetime,
	@SlotPrice money
	as
	begin
		if (CONVERT(date, @StartTime) = CONVERT(date, @EndTime))
		begin
			if (@Description not like '0')
			begin
				insert into Workshops (ConferenceDayID, Title, Description, Slots, SlotsLeft, StartTime, EndTime, SlotPrice)
				values (@ConferenceDayID, @Title, @Description, @Slots, @Slots, @StartTime, @EndTime, @SlotPrice)
			end
			else
				insert into Workshops (ConferenceDayID, Title, Description, Slots, SlotsLeft, StartTime, EndTime, SlotPrice)
				values (@ConferenceDayID, @Title, NULL, @Slots, @Slots, @StartTime, @EndTime, @SlotPrice)
		end
		else
		begin
			THROW 51000, 'Workshop cannot last more than 1 day', 1
		end
	end
go



IF OBJECT_ID('dbo.AddConferenceReservation') IS NOT NULL
DROP PROC dbo.AddConferenceReservation
GO

create procedure AddConferenceReservation
	@ClientID int,
	@ConferenceDayID int,
	@ReservationDate date,
	@ReservationSlots int,
	@ReservationStudents int,
	@Canceled bit
	as
	begin
	if (((select ClientID from ConferenceReservation where ClientID=@ClientID and ConferenceDayID=@ConferenceDayID) is null) and @ReservationSlots <= (select SlotsLeft from ConferenceDay where ConferenceDayID = @ConferenceDayID))
		begin
			if (@Canceled <> 1) -- na potrzeby generatora :)
			begin
				declare @SlotPrice int = (select top 1 SlotPrice from PricesInfo where ConferenceDayID=@ConferenceDayID and Expires >= @ReservationDate order by Expires)
				declare @Discount int = (select top 1 StudentDiscount from PricesInfo where ConferenceDayID=@ConferenceDayID and Expires >= @ReservationDate)
				if (@SlotPrice is null and @Discount is null)
				begin
					THROW 51000, 'Theres is no info about prices connected', 1
				end
				else
				begin
					update ConferenceDay
					set SlotsLeft = SlotsLeft-@ReservationSlots
					where ConferenceDayID = @ConferenceDayID
					insert into ConferenceReservation (ClientID, ConferenceDayID, ReservationDate, ReservationSlots, ReservationStudents, ReservationPrice, Canceled)
					values (@ClientID, @ConferenceDayID, @ReservationDate, @ReservationSlots, @ReservationStudents,
					@SlotPrice*(@ReservationSlots-@ReservationStudents)+@ReservationStudents*(1-@Discount*0.01), @Canceled)
				end
			end
			else
			begin
				insert into ConferenceReservation (ClientID, ConferenceDayID, ReservationDate, ReservationSlots, ReservationStudents, ReservationPrice, Canceled)
				values (@ClientID, @ConferenceDayID, @ReservationDate, @ReservationSlots, @ReservationStudents, 0, @Canceled)
			end
		end
		else
		begin
			THROW 51000, 'Conference has not enough slots or is already registered', 1
		end
	end
go



IF OBJECT_ID('dbo.AddWorkshopReservation') IS NOT NULL
DROP PROC dbo.AddWorkshopReservation
GO

create procedure AddWorkshopReservation
	@WorkshopID int,
	@ConferenceReservationID int,
	@ReservationSlots int,
	@Canceled bit
	as
	begin
		declare @ClientID int = (select ClientID from ConferenceReservation where ConferenceReservationID = @ConferenceReservationID)
		declare @ConferenceDayID int = (select ConferenceDayID from ConferenceReservation where ConferenceReservationID = @ConferenceReservationID)
		if ((select ConferenceReservationID from ConferenceReservation where ClientID = @ClientID and ConferenceDayID = @ConferenceDayID) is not null and 
		(select WorkshopID from WorkshopReservation where WorkshopID=@WorkshopID and ConferenceReservationID = @ConferenceReservationID) is null and 
		@ReservationSlots <= (select SlotsLeft from Workshops where WorkshopID = @WorkshopID))
		begin
			if (@Canceled <> 1) --na potrzeby generatora
			begin
				update Workshops
				set SlotsLeft = SlotsLeft - @ReservationSlots
				where WorkshopID = @WorkshopID
				begin
					insert into WorkshopReservation (WorkshopID, ConferenceReservationID, ReservationSlots, ReservationPrice, Canceled)
					values (@WorkshopID, @ConferenceReservationID, @ReservationSlots, @ReservationSlots * (select SlotPrice from Workshops where WorkshopID = @WorkshopID), @Canceled)
				end
			end
			else
			begin
				insert into WorkshopReservation (WorkshopID, ConferenceReservationID, ReservationSlots, ReservationPrice, Canceled)
				values (@WorkshopID, @ConferenceReservationID, @ReservationSlots, 0, @Canceled)
			end
		end
		else
		begin
			THROW 51000, 'Company has to be registered to the conferences first or is already registered or there is not enough slots left', 1
		end
	end
go



IF OBJECT_ID('dbo.AddConferenceParticipantNotification') IS NOT NULL
DROP PROC dbo.AddConferenceParticipantNotification
GO

create procedure AddConferenceParticipantNotification
	@ParticipantID int,
	@ConferenceReservationID int
	as
	begin
		if ((select ConferenceParticipantNotificationID from ConferenceParticipantNotification where ParticipantID = @ParticipantID and ConferenceReservationID = @ConferenceReservationID) is null)
		begin
			insert into ConferenceParticipantNotification (ParticipantID, ConferenceReservationID)
			values (@ParticipantID, @ConferenceReservationID)
		end
		else
		begin
			THROW 51000, 'Participant is already registered on that day', 1
		end
	end
go



IF OBJECT_ID('dbo.AddWorkshopParticipantNotification') IS NOT NULL
DROP PROC dbo.AddWorkshopParticipantNotification
GO

create procedure AddWorkshopParticipantNotification
	@WorkshopReservationID int,
	@ConferenceParticipantNotificationID int
	as
	begin
		if ((select ParticipantID from ConferenceParticipantNotification where ConferenceParticipantNotificationID=@ConferenceParticipantNotificationID) is not null)
		begin
		if ((select WorkshopParticipantNotificationID from WorkshopParticipantNotification where WorkshopReservationID = @WorkshopReservationID and ConferenceParticipantNotificationID = @ConferenceParticipantNotificationID) is null)
			begin
				insert into WorkshopParticipantNotification (WorkshopReservationID, ConferenceParticipantNotificationID)
				values (@WorkshopReservationID, @ConferenceParticipantNotificationID)
			end
			else
			begin
				THROW 51000, 'Participant is already registered on that workshop', 1
			end
		end
		else
		begin
			THROW 51000, 'Participant has to be registered to a conference first', 1
		end
	end
go



IF OBJECT_ID('dbo.AddPayment') IS NOT NULL
DROP PROC dbo.AddPayment
GO

create procedure AddPayment
	@ConferenceReservationID int,
	@Amount money,
	@Date date
	as
	begin
		insert into Payments (ConferenceReservationID, Amount, Date)
		values (@ConferenceReservationID, @Amount, @Date)
	end
go



IF OBJECT_ID('dbo.ChangeReservationSlots') IS NOT NULL
DROP PROC dbo.ChangeReservationSlots
GO

create procedure ChangeReservationSlots
	@ConferenceReservationID int,
	@ReservationSlots int,
	@ReservationStudents int,
	@ReservationDate date
	as
	begin
		declare @ConferenceDayID int = (select ConferenceDayID from ConferenceReservation where ConferenceReservationID = @ConferenceReservationID)
		if (((select sum(ReservationSlots) from ConferenceReservation where ConferenceDayID = @ConferenceDayID)+@ReservationSlots)<=(select Slots from ConferenceDay where ConferenceDayID = @ConferenceDayID))
			begin 
				declare @SlotPrice int = (select top 1 SlotPrice from PricesInfo where ConferenceDayID=@ConferenceDayID and Expires >= @ReservationDate order by Expires),
				@Discount int = (select top 1 StudentDiscount from PricesInfo where ConferenceDayID=@ConferenceDayID and Expires >= @ReservationDate)
				if (@SlotPrice is null and @Discount is null)
				begin
					THROW 51000, 'Theres is no info about prices connected', 1
				end
				else
				begin
					update ConferenceReservation
					set ReservationSlots = @ReservationSlots, ReservationStudents = @ReservationStudents,
					ReservationPrice = @SlotPrice*(@ReservationSlots-@ReservationStudents)+@ReservationStudents*(1-@Discount*0.01), ReservationDate = @ReservationDate
					where ConferenceReservationID = @ConferenceReservationID
				end
			end
		else
		begin
			THROW 51000, 'Conference day has not enough slots for your change request', 1
		end
	end
go



IF OBJECT_ID('dbo.DeleteUnpaidReservations') IS NOT NULL
DROP PROC dbo.DeleteUnpaidReservations
GO

create procedure DeleteUnpaidReservations 
	as
	begin
declare cur cursor local for (select cr.ConferenceReservationID from ConferenceReservation cr
left outer join Payments p on cr.ConferenceReservationID=p.ConferenceReservationID
		left outer join ConferenceDay cd on cr.ConferenceDayID = cd.ConferenceDayID
		where Amount is null and datediff(day, cr.ReservationDate, cd.Date) > 7)
		declare @UnpaidReservationID int
		open cur
			fetch next from cur into @UnpaidReservationID
			while @@FETCH_STATUS = 0
			begin
				delete ConferenceReservation
				where ConferenceReservationID = @UnpaidReservationID
				fetch next from cur into @UnpaidReservationID
			end
		close cur
		deallocate cur
	end
go




IF OBJECT_ID('dbo.CancelWorkshopReservation') IS NOT NULL
DROP PROC dbo.CancelWorkshopReservation
GO

create proc CancelWorkshopReservation
	@WorkshopReservationID int
	as
	begin
if (select Canceled from WorkshopReservation where WorkshopReservationID = @WorkshopReservationID) <> 1
			begin
				update WorkshopReservation
				set Canceled = 1
				where WorkshopReservationID = @WorkshopReservationID
				delete WorkshopParticipantNotification
				where WorkshopReservationID = @WorkshopReservationID
declare @WorkshopID int = (select WorkshopID from WorkshopReservation where WorkshopReservationID = @WorkshopReservationID)
declare @ReservationSlots int = (select ReservationSlots from WorkshopReservation where WorkshopReservationID = @WorkshopReservationID)
				update Workshops
				set SlotsLeft = SlotsLeft + @ReservationSlots
			end
	end
go



IF OBJECT_ID('dbo.CancelConferenceReservation') IS NOT NULL
DROP PROC dbo.CancelConferenceReservation
GO

create proc CancelConferenceReservation
	@ConferenceReservationID int
	as
	begin
if (select Canceled from ConferenceReservation where ConferenceReservationID = @ConferenceReservationID) <> 1
			begin
				update ConferenceReservation
				set Canceled = 1
				where ConferenceReservationID = @ConferenceReservationID
declare cur cursor local for (select WorkshopReservationID from WorkshopReservation where ConferenceReservationID = @ConferenceReservationID)
				declare @WorkshopReservationID int
				open cur
				while @@FETCH_STATUS = 0
				begin
					fetch next from cur into @WorkshopReservationID
					exec CancelWorkshopReservation @WorkshopReservationID
				end
				close cur
				deallocate cur
				delete ConferenceParticipantNotification
				where ConferenceReservationID = @ConferenceReservationID
			end
		else
		begin
			THROW 51000, 'Reservation is already canceled', 1
		end
	end
go




-- triggers
IF OBJECT_ID('dbo.RemoveConferenceConnectedComponents') IS NOT NULL
DROP TRIGGER dbo.RemoveConferenceConnectedComponents
GO

create trigger RemoveConferenceConnectedComponents
	on ConferenceReservation
	after delete
	as
	begin
		declare @DeletedConferenceReservationID int = (select ConferenceReservationID from deleted)
		delete WorkshopReservation
		where ConferenceReservationID = @DeletedConferenceReservationID
		delete ConferenceParticipantNotification
		where ConferenceReservationID = @DeletedConferenceReservationID
	end
go



IF OBJECT_ID('dbo.RemoveWorkshopConnectedComponents') IS NOT NULL
DROP TRIGGER dbo.RemoveWorkshopConnectedComponents
GO

create trigger RemoveWorkshopConnectedComponents
	on WorkshopReservation
	after delete
	as
	begin
		declare @DeletedWorkshopReservationID int = (select WorkshopReservationID from deleted)
		delete WorkshopParticipantNotification
		where WorkshopReservationID = @DeletedWorkshopReservationID
	end
go



IF OBJECT_ID('dbo.SeparatedConferences') IS NOT NULL
DROP TRIGGER dbo.SeparatedConferences
GO

create trigger SeparatedConferences
	on Conferences
	after insert, update
	as
	begin
		declare @Start date = (select StartDate from inserted)
		declare @End date = (select EndDate from inserted)
		declare @ConferenceID int = (select ConferenceID from Inserted)
		if ((select ConferenceID from Conferences where (@Start between StartDate and EndDate or @End between StartDate and EndDate) and ConferenceID <> @ConferenceID) is not null)
		begin
			THROW 51000, 'Conferences cannot collide', 1
		end
	end
go



IF OBJECT_ID('dbo.WorkshopCollideParticipant') IS NOT NULL
DROP TRIGGER dbo.WorkshopCollideParticipant
GO

create trigger WorkshopCollideParticipant
	on WorkshopParticipantNotification
	after insert
	as
	begin
		declare @WorkshopReservationID int = (select WorkshopReservationID from inserted)
		declare @ConferenceParticipantNotificationID int = (select ConferenceParticipantNotificationID from inserted)
		delete WorkshopParticipantNotification
		where WorkshopReservationID = @WorkshopReservationID and ConferenceParticipantNotificationID = @ConferenceParticipantNotificationID
		declare @WorkshopIDinserted int = (select WorkshopID from WorkshopReservation where WorkshopReservationID = @WorkshopReservationID)
		declare @Start datetime = (select StartTime from Workshops where WorkshopID = @WorkshopIDinserted)
		declare @End datetime = (select EndTime from Workshops where WorkshopID = @WorkshopIDinserted)
		if (select ParticipantID from ConferenceParticipantNotification cpn 
			inner join WorkshopParticipantNotification wpn on cpn.ConferenceParticipantNotificationID = wpn.ConferenceParticipantNotificationID
			inner join WorkshopReservation wr on wpn.WorkshopReservationID = wr.WorkshopReservationID
			inner join Workshops w on wr.WorkshopID = w.WorkshopID
			where @ConferenceParticipantNotificationID = cpn.ConferenceParticipantNotificationID and @Start <> w.StartTime and @End <> w.EndTime and
			(@Start between w.StartTime and w.EndTime or @End between w.StartTime and w.EndTime))is not null
			begin
				THROW 51000, 'Participant cannot attend 2 workshops in same time', 1
			end
			else
			begin
				insert into WorkshopParticipantNotification (WorkshopReservationID, ConferenceParticipantNotificationID)
				values (@WorkshopReservationID, @ConferenceParticipantNotificationID)
			end
	end
go



IF OBJECT_ID('dbo.PricesInfoExpire') IS NOT NULL
DROP TRIGGER dbo.PricesInfoExpire
GO


create trigger PricesInfoExpire
	on PricesInfo
	after insert, update
	as
	begin
		declare @Expire date = (select Expires from inserted)
		declare @ConferenceDayID int = (select ConferenceDayID from inserted)
		if ((select Date from ConferenceDay where ConferenceDayID = @ConferenceDayID) < @Expire)
		begin
			THROW 51000, 'Wrong expire date', 1
		end
	end
go




-- functions
IF OBJECT_ID('dbo.HowMuchSHouldIPay') IS NOT NULL
DROP FUNCTION dbo.HowMuchSHouldIPay
GO

create function HowMuchSHouldIPay
	(
		@ClientReservationID int
	)
	returns money
	as
	begin
		return (select ReservationPrice from ConferenceReservation where ConferenceReservationID = @ClientReservationID)
		+ (select isnull(sum(ReservationPrice),0) from WorkshopReservation where ConferenceReservationID = @ClientReservationID)
	end
go


IF OBJECT_ID('dbo.ParticipantsSlotsLeftConference') IS NOT NULL
DROP FUNCTION dbo.ParticipantsSlotsLeftConference
GO

create function ParticipantsSlotsLeftConference
	(
		@ClientConferenceReservationID int
	)
	returns int
	as
	begin
		return (select ReservationSlots from ConferenceReservation where ConferenceReservationID = @ClientConferenceReservationID)
		- (select count(ConferenceParticipantNotifictionID) from ConferenceParticipantNotifiction where ConferenceReservationID = @ClientConferenceReservationID)
	end
go



IF OBJECT_ID('dbo.ParticipantsSlotsLeftWorkshop') IS NOT NULL
DROP FUNCTION dbo.ParticipantsSlotsLeftWorkshop
GO

create function ParticipantsSlotsLeftWorkshop
	(
		@ClientWorkshopReservationID int
	)
	returns int
	as
	begin
		return (select ReservationSlots from WorkshopReservation where ConferenceReservationID = @ClientWorkshopReservationID)
		- (select count(WorkshopParticipantNotifictionID) from WorkshopParticipantNotifiction where WorkshopReservationID = @ClientWorkshopReservationID)
	end
go



IF OBJECT_ID('dbo.ConferenceSlots') IS NOT NULL
DROP FUNCTION dbo.ConferenceSlots
GO

create function ConferenceSlots
	(
		@ConferenceID int
	)
	returns int
	as
	begin
		return (select sum(Slots) from ConferenceDay where ConferenceID = @ConferenceID)
	end
go



IF OBJECT_ID('dbo.HowManyConferenceDays') IS NOT NULL
DROP FUNCTION dbo.HowManyConferenceDays
GO

create function HowManyConferenceDays
	(
		@ConferenceID int
	)
	returns money
	as
	begin
		return (select count(ConferenceDayID) from ConferenceDay where ConferenceID = @ConferenceID)
	end
go



-- views

IF OBJECT_ID('dbo.ReservationsAndPayments') IS NOT NULL
DROP VIEW dbo.ReservationsAndPayments
GO


create view ReservationsAndPayments
	as
	select CompanyName, ClientFirstname, ClientLastname, cr.ConferenceReservationID, ReservationDate, Amount, Date from ConferenceReservation cr
	left join Payments p  on cr.ConferenceReservationID = p.ConferenceReservationID
	inner join Clients c on cr.ClientID = c.ClientID
go



IF OBJECT_ID('dbo.Top10Clients') IS NOT NULL
DROP VIEW dbo.Top10Clients
GO

create view Top10Clients
	as
	select top 10 CompanyName, ClientFirstname, ClientLastname, sum(ReservationPrice) as 'Ca³kowita liczba rezerwacji' from ConferenceReservation cr
	inner join Clients c on cr.ClientID = c.ClientID
	group by CompanyName, ClientFirstname, ClientLastname
	order by 4 desc
go


IF OBJECT_ID('dbo.ConferenceParticipants') IS NOT NULL
DROP VIEW dbo.ConferenceParticipants
GO

create view ConferenceParticipants
	as
	select p.ParticipantFirstname, p.ParticipantLastname, c.Name, c.StartDate, c.EndDate from ConferenceParticipantNotification cnp
	inner join Participants p on cnp.ParticipantID = p.ParticipantID
	inner join ConferenceReservation cr on cnp.ConferenceReservationID = cr.ConferenceReservationID
	inner join ConferenceDay cd on cd.ConferenceDayID = cr.ConferenceDayID
	inner join Conferences c on c.ConferenceID = cd.ConferenceID
go



IF OBJECT_ID('dbo.WorkshopParticipants') IS NOT NULL
DROP VIEW dbo.WorkshopParticipants
GO


create view WorkshopParticipants
	as
	select p.ParticipantFirstname, p.ParticipantLastname, w.Title, w.StartTime, w.EndTime from WorkshopParticipantNotification wpn
	inner join ConferenceParticipantNotification cpn on wpn.ConferenceParticipantNotificationID = cpn.ConferenceParticipantNotificationID
	inner join Participants p on cpn.ParticipantID = p.ParticipantID
	inner join WorkshopReservation wr on wpn.WorkshopReservationID = wr.WorkshopReservationID
	inner join Workshops w on w.WorkshopID = wr.WorkshopID
go



IF OBJECT_ID('dbo.WorkshopDuringConference') IS NOT NULL
DROP VIEW dbo.WorkshopDuringConference
GO

create view WorkshopDuringConference
	as
	select w.Title as 'Workshop title', c.Name as 'Conference name', 'At days from '+cast(c.StartDate as varchar(50))+' to '+cast(c.EndDate as varchar(50))
	as 'Conference lasts' from Workshops w
	inner join ConferenceDay cd on cd.ConferenceDayID = w.ConferenceDayID
	inner join Conferences c on c.ConferenceID = cd.ConferenceID
go



IF OBJECT_ID('dbo.WorkshopParticipants') IS NOT NULL
DROP VIEW dbo.WorkshopParticipants
GO

create view WorkshopParticipants
	as
select top 10 p.ParticipantFirstname, p.ParticipantLastname, count(cpn.ParticipantID) as 'Liczba odbytych konferencji wraz z warsztatami' from Participants p
	inner join ConferenceParticipantNotification cpn on cpn.ParticipantID = p.ParticipantID
	inner join ConferenceReservation cr on cpn.ConferenceReservationID = cr.ConferenceReservationID
	where Canceled <> 1
	group by p.ParticipantFirstname, p.ParticipantLastname
	order by 3 desc
go