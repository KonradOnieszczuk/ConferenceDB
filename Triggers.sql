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
		if ((select ConferenceID from Conferences where @Start between StartDate and EndDate or @End between StartDate and EndDate) is not null)
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
		declare @WorkshopIDinserted int = (select WorkshopID from WorkshopReservation where WorkshopReservationID = @WorkshopReservationID)
		declare @Start datetime = (select StartTime from Workshops where WorkshopID = @WorkshopIDinserted)
		declare @End datetime = (select EndTime from Workshops where WorkshopID = @WorkshopIDinserted)
		if (select ParticipantID from ConferenceParticipantNotification cpn 
			inner join WorkshopParticipantNotification wpn on cpn.ConferenceParticipantNotificationID = wpn.ConferenceParticipantNotificationID
			inner join WorkshopReservation wr on wpn.WorkshopReservationID = wr.WorkshopReservationID
			inner join Workshops w on wr.WorkshopID = w.WorkshopID
			where @ConferenceParticipantNotificationID = cpn.ConferenceParticipantNotificationID and 
			(@Start between w.StartTime and w.EndTime or @End between w.StartTime and w.EndTime))is not null
			begin
				THROW 51000, 'Participant cannot attend 2 workshops in same time', 1
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
		if ((select Date from ConferenceDat where COnferenceDayID = @ConferenceDayID) < @Expire)
		begin
			THROW 51000, 'Wrong expire date', 1
		end
	end
go