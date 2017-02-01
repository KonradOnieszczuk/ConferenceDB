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