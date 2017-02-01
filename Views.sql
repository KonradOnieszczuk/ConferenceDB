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