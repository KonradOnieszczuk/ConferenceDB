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