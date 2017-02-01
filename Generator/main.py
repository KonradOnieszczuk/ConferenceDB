import pypyodbc
import functions
import random

#dane do połączenia z bazą danych, w moim przypadku jest to baza lokalna
cnxn_string ="Driver={SQL Server};Server=BANGER\\SQLEXPRESS;Database=Konferencje_Onieszczuk;Trusted_Connection=Yes;"



cnxn = pypyodbc.connect(cnxn_string)

functions.AddClientCompany(cnxn,random.randrange(100,150,5))

functions.AddClientPrivate(cnxn,random.randrange(100,150,5))

functions.AddParticipant(cnxn,random.randrange(2000,3000,100))

functions.AddConference(cnxn)

functions.AddConferenceReservation(cnxn, random.randint(250,300))

functions.AddPayments(cnxn)

functions.AddConferenceParticipantNotification(cnxn)

functions.AddWorkshopParticipantNotification(cnxn)



cnxn.close()

