-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2016-01-17 22:24:55.817






-- foreign keys
ALTER TABLE ConferenceReservation DROP CONSTRAINT ConfReservation_ConfDay;

ALTER TABLE ConferenceDay DROP CONSTRAINT ConferenceDay_Conferences;

ALTER TABLE ConferenceParticipantNotification DROP CONSTRAINT ConferenceParticipants_ConferenceReservation;

ALTER TABLE ConferenceParticipantNotification DROP CONSTRAINT ConferenceParticipants_Participants;

ALTER TABLE ConferenceReservation DROP CONSTRAINT ConferenceReservation_Clients;

ALTER TABLE Payments DROP CONSTRAINT Payments_ConferenceReservation;

ALTER TABLE PricesInfo DROP CONSTRAINT PricesInfo_ConferenceDay;

ALTER TABLE WorkshopParticipantNotification DROP CONSTRAINT WPN_CPN;

ALTER TABLE WorkshopParticipantNotification DROP CONSTRAINT WorkshopParticipants_WorkshopReservation;

ALTER TABLE WorkshopReservation DROP CONSTRAINT WorkshopReservation_ConferenceReservation;

ALTER TABLE WorkshopReservation DROP CONSTRAINT WorkshopReservation_Workshops;

ALTER TABLE Workshops DROP CONSTRAINT Workshops_ConferenceDay;





-- tables
DROP TABLE Clients;
DROP TABLE ConferenceDay;
DROP TABLE ConferenceParticipantNotification;
DROP TABLE ConferenceReservation;
DROP TABLE Conferences;
DROP TABLE Participants;
DROP TABLE Payments;
DROP TABLE PricesInfo;
DROP TABLE WorkshopParticipantNotification;
DROP TABLE WorkshopReservation;
DROP TABLE Workshops;




-- End of file.

