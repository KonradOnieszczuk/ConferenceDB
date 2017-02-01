import data
import datetime
import random
from dateutil.relativedelta import relativedelta
from dateutil import parser
import os

#ścieżka do zapisania pliku log na dysku
writepath = "C:\\Users\k2nder\\Desktop\\log_generator.txt"

if os.path.exists(writepath):
    with open(writepath, 'a') as log:
        log.write("use Konferencje_Onieszczuk\n")
else:
    with open(writepath, 'w') as log:
        log.write("use Konferencje_Onieszczuk\n")
mode = 'a'



def AddClientCompany (cnxn, n):
    cur = cnxn.cursor()
    while n > 0:
        c = data.ClientCompany()
        SQL = "select ClientID from Clients where Email like '{}' or Phone like '{}'".format(c.Email, c.Phone)
        if (cur.execute(SQL).fetchone() is None):
            SQL = "exec AddClientCompany '{}', 'Polska', '{}', '{}', '{}', '{}', '{}', '{}'".format(c.CompanyName, c.City, c.Address,c.PostCode, c.Phone, c.Email, c.Password)
            cnxn.cursor().execute(SQL).commit()
            with open(writepath, mode) as log:
                log.write("exec AddClientCompany '{}', 'Polska', '{}', '{}', '{}', '{}', '{}', '{}'\n".format(c.CompanyName, c.City, c.Address,c.PostCode, c.Phone, c.Email, c.Password))
            n = n-1
        else:
            continue
    return;


def AddClientPrivate (cnxn, n):
    cur = cnxn.cursor()
    while n > 0:
        c = data.ClientPrivate()
        SQL = "select ClientID from Clients where Email like '{}' or Phone like '{}'".format(c.Email, c.Phone)
        if (cur.execute(SQL).fetchone() is None):
            SQL = "exec AddClientPrivate '{}', 'Polska', '{}', '{}', '{}', '{}', '{}', '{}', '{}'".format(c.ClientFirstname, c.ClientLastname, c.City, c.Address, c.PostCode, c.Phone, c.Email, c.Password)
            cnxn.cursor().execute(SQL).commit()
            n = n-1
            with open(writepath, mode) as log:
                log.write("exec AddClientPrivate '{}', 'Polska', '{}', '{}', '{}', '{}', '{}', '{}', '{}'\n".format(c.ClientFirstname, c.ClientLastname, c.City, c.Address, c.PostCode, c.Phone, c.Email, c.Password))
        else:
            continue
    return;


def AddParticipant (cnxn, n):
    cur=cnxn.cursor()
    while n > 0:
        p = data.Participant()
        SQL = "select ParticipantID from Participants where Email like '{}' or StudentID like '{}'".format(p.Email, p.StudentID)
        if (cur.execute(SQL).fetchone() is None):
            SQL = "exec AddParticipant '{}', '{}', '{}', '{}', '{}'".format(p.ParticipantFirstname, p.ParticipantLastname, p.Email, p.Password, p.StudentID)
            cnxn.cursor().execute(SQL).commit()
            with open(writepath, mode) as log:
                log.write("exec AddParticipant '{}', '{}', '{}', '{}', '{}'\n".format(p.ParticipantFirstname, p.ParticipantLastname, p.Email, p.Password, p.StudentID))
            n = n-1
        else:
            continue
    return;



def AddConference (cnxn):
    StartDate = datetime.date.today()-relativedelta(years=3)
    while StartDate+relativedelta(days=25)<datetime.date.today():
        StartDate = StartDate+relativedelta(days = (random.randint(10, 25)))
        EndDate = StartDate+relativedelta(days = (random.randint(0, 5)))
        c = data.Conference()
        SQL = "exec AddConference '{}', '{}', '{}', '{}', '{}'".format(c.Name, c.Place, c.Description, StartDate, EndDate)
        cnxn.cursor().execute(SQL).commit()
        with open(writepath, mode) as log:
                log.write("exec AddConference '{}', '{}', '{}', '{}', '{}'\n".format(c.Name, c.Place, c.Description, StartDate, EndDate))

        AddConferenceDay(cnxn, StartDate, EndDate)

    return;


def AddConferenceDay (cnxn, StartDate, EndDate):
    cur = cnxn.cursor()
    SQL = "select ConferenceID from Conferences where StartDate like '%s'" % StartDate
    id = cur.execute(SQL).fetchone()[0]
    count = 0
    for _ in range ((EndDate-StartDate).days):
        ConferenceDate = StartDate+relativedelta(days=count)
        slots = random.randrange(50,100,10)
        SQL = "exec AddConferenceDay '{}', '{}', '{}'".format(id, slots, ConferenceDate)
        cnxn.cursor().execute(SQL).commit()
        with open(writepath, mode) as log:
                log.write("exec AddConferenceDay '{}', '{}', '{}'\n".format(id, slots, ConferenceDate))
        count = count+1

        AddPricesInfo(cnxn, ConferenceDate)

        AddWorkshop(cnxn, ConferenceDate)

    return;


def AddPricesInfo (cnxn, ConferenceDate):
    cur = cnxn.cursor()
    SQL = "select ConferenceDayID from ConferenceDay where Date like '%s'" % ConferenceDate
    id = cur.execute(SQL).fetchone()[0]
    randcount = random.randint(1, 4)
    expirecount = randcount - 1
    for _ in range (randcount):
        expires = (ConferenceDate - relativedelta(days=14*expirecount))
        price = random.randrange(10,50,5)
        discount = random.randrange(0,100,5)
        SQL = "exec AddPricesInfo '{}', '{}', '{}', '{}'".format(id, expires, price, discount)
        cnxn.cursor().execute(SQL).commit()
        with open(writepath, mode) as log:
            log.write("exec AddPricesInfo '{}', '{}', '{}', '{}'\n".format(id, expires, price,  discount))
        expirecount = expirecount - 1
    return;

def AddWorkshop (cnxn, ConferenceDate):
    cur = cnxn.cursor()
    w = data.Workshop()
    SQL = "select ConferenceDayID from ConferenceDay where Date like '%s'" % ConferenceDate
    StartTime = ConferenceDate + relativedelta (hours=random.randint(9, 11)) # srednio o 9,11 sie rozpoczynaja
    cur.execute(SQL)
    id = cur.fetchone()[0]
    randcount = random.randint(0, 6) #
    for _ in range (randcount):
        EndTime = (StartTime+relativedelta (hours=random.randint(1, 2)))
        SQL = "exec AddWorkshop '{}', '{}', '{}', '{}', '{}', '{}', '{}'".format(id, w.Title, w.Description, w.Slots, StartTime, EndTime, w.SlotPrice)
        cnxn.cursor().execute(SQL).commit()
        with open(writepath, mode) as log:
            log.write("exec AddWorkshop '{}', '{}', '{}', '{}', '{}', '{}', '{}'\n".format(id, w.Title, w.Description, w.Slots, StartTime, EndTime, w.SlotPrice))
        if (StartTime.day == ConferenceDate.day): # one day warranty
            StartTime = StartTime + relativedelta (hours = random.randint(0, 2))
        else:
            break
    return;

def AddConferenceReservation (cnxn, n):
    cur = cnxn.cursor()
    SQL = "select ConferenceDayID from ConferenceDay"
    days = []
    cur.execute(SQL)
    for row in cur:
        days.append(row[0])
    SQL = "select ClientID from Clients"
    clients =[]
    cur.execute(SQL)
    for row in cur:
        clients.append(row[0])
    for _ in range (n):
        ConferenceDayID = random.choice(days)
        ClientID = random.choice(clients)
        SQL = "select SlotsLeft from ConferenceDay where ConferenceDayID like '{}'".format(ConferenceDayID)
        slotsleft = cur.execute(SQL).fetchone()[0]
        SQL = "select Date from ConferenceDay where ConferenceDayID like '{}'".format(ConferenceDayID)
        date = parser.parse(cur.execute(SQL).fetchone()[0]).date()
        if (slotsleft >= 10 ):
            resdate = date - relativedelta(days=7*(random.randint(1,8)))
            slots = random.randrange(10,slotsleft+1,10)
            SQL = "select ConferenceReservationID from ConferenceReservation where ClientID = '{}' and ConferenceDayID ='{}'".format(ClientID, ConferenceDayID)
            if (cur.execute(SQL).fetchone() is None): # unique

                students = random.randrange(0,slots,1)
                cancel = random.choice([0,0,1])
                SQL = "exec AddConferenceReservation '{}', '{}', '{}', '{}', '{}', '{}'".format(ClientID, ConferenceDayID, resdate, slots, students, cancel)
                cnxn.cursor().execute(SQL).commit()
                with open (writepath, mode) as log:
                    log.write("exec AddConferenceReservation '{}', '{}', '{}', '{}', '{}', '{}'\n".format(ClientID, ConferenceDayID, resdate, slots, students, cancel))
                if (cancel == 0):
                    AddWorkshopReservation(cnxn, ClientID, ConferenceDayID, slots) # when conference reservation is canceled we do not add workshop one
                else:
                    continue
            else:
                continue
        else:
            continue

    return;

def AddWorkshopReservation (cnxn, ClientID, ConferenceDayID, slots):
    cur = cnxn.cursor()
    SQL = "select ConferenceReservationID from ConferenceReservation where ClientID like '{}' and ConferenceDayID like '{}'".format(ClientID, ConferenceDayID)
    resid = cur.execute(SQL).fetchone()[0]
    SQL = "select WorkshopID from Workshops where ConferenceDayID like '{}'".format(ConferenceDayID)
    cur.execute(SQL)
    workids = []
    for row in cur:
        workids.append(row[0])
    for _ in range (len(workids)):
        workid = workids.pop(0)
        SQL = "select SlotsLeft from Workshops where WorkshopID like '{}'".format(workid)
        slotsleft = cur.execute(SQL).fetchone()[0]
        if (slots > slotsleft):
            slotsleft = slotsleft
        else:
            slotsleft = slots
        if (slotsleft >= 10):
            slots = random.randrange(1,int((slotsleft+1)/3),1)
            SQL = "select WorkshopReservationID from WorkshopReservation where WorkshopID like '{}' and ConferenceReservationID like '{}'".format(workid, resid)
            if (cur.execute(SQL).fetchone() is None): # zapobiegamy dwukrotnemu wpisaniu
                    cancel = random.choice([0,0,0,0,0,1])
                    SQL = "exec AddWorkshopReservation '{}', '{}', '{}', '{}'".format(workid, resid, slots, cancel)
                    cnxn.cursor().execute(SQL).commit()
                    with open (writepath, mode) as log:
                        log.write("exec AddWorkshopReservation '{}', '{}', '{}', '{}'\n".format(workid, resid, slots, cancel))
            else:
                continue
        else:
            continue
    return;

def AddConferenceParticipantNotification (cnxn):
    cur = cnxn.cursor()
    SQL = "select ConferenceReservationID from ConferenceReservation where Canceled = 0" # only not canceled
    resids = []
    cur.execute(SQL)
    for row in cur:
        resids.append(row[0])
    for _ in range(len(resids)):
        resid = resids.pop(0)
        SQL = "select ReservationSlots, ReservationStudents from ConferenceReservation where ConferenceReservationID like '{}'".format(resid)
        slots = cur.execute(SQL).fetchone()[0]
        studs = cur.execute(SQL).fetchone()[1]
        slots = slots-studs
        while (slots > 0):
            SQL = "select ParticipantID from Participants where StudentID is null"
            pids = []
            cur.execute(SQL)
            for row in cur:
                pids.append(row[0])
            pid = random.choice(pids)
            SQL = "select ConferenceParticipantNotificationID from ConferenceParticipantNotification where ParticipantID like '{}' and ConferenceReservationID like '{}'".format(pid, resid)
            if (cur.execute(SQL).fetchone() is None):
                SQL = "exec AddConferenceParticipantNotification '{}', '{}'".format(pid, resid)
                cnxn.cursor().execute(SQL).commit()
                with open (writepath, mode) as log:
                        log.write("exec AddConferenceParticipantNotification '{}', '{}'\n".format(pid, resid))
                slots = slots - 1
            else:
                continue
        while (studs > 0):
            SQL = "select ParticipantID from Participants where StudentID is not null"
            pids = []
            cur.execute(SQL)
            for row in cur:
                pids.append(row[0])
            pid=random.choice(pids)
            SQL = "select ConferenceParticipantNotificationID from ConferenceParticipantNotification where ParticipantID like '{}' and ConferenceReservationID like '{}'".format(pid, resid)
            if (cur.execute(SQL).fetchone() is None):
                SQL = "exec AddConferenceParticipantNotification '{}', '{}'".format(pid, resid)
                cnxn.cursor().execute(SQL).commit()
                with open (writepath, mode) as log:
                        log.write("exec AddConferenceParticipantNotification '{}', '{}'\n".format(pid, resid))
                studs = studs - 1
            else:
                continue
    return;


def AddWorkshopParticipantNotification(cnxn):
    cur = cnxn.cursor()
    SQL = "select WorkshopReservationID from WorkshopReservation where Canceled = 0" # only not canceled
    resids = []
    cur.execute(SQL)
    for row in cur:
        resids.append(row[0])
    for _ in range(len(resids)):
        resid = resids.pop(0)
        SQL = "select WorkshopID from WorkshopReservation where WorkshopReservationID like '{}'".format(resid)
        workid=cur.execute(SQL).fetchone()[0]
        SQL = "select ConferenceReservationID from WorkshopReservation where WorkshopID like '{}'".format(workid)
        confid = cur.execute(SQL).fetchone()[0]
        SQL = "select ReservationSlots from WorkshopReservation where WorkshopReservationID like '{}'".format(resid)
        slots=cur.execute(SQL).fetchone()[0]
        while (slots > 0):
            SQL = "select ConferenceParticipantNotificationID from ConferenceParticipantNotification where ConferenceReservationID like '{}'".format(confid) # zachowany warunek uczestnictwa w konferencji
            pids = []
            cur.execute(SQL)
            for row in cur:
                pids.append(row[0])
            pid = random.choice(pids)
            SQL = "select WorkshopParticipantNotificationID from WorkshopParticipantNotification where ConferenceParticipantNotificationID = {} and WorkshopReservationID = {}".format(pid, resid)
            if (cur.execute(SQL).fetchone() is None): # unique check
                SQL = "select EndTime from Workshops where WorkshopID like '{}'".format(workid)
                endmain=cur.execute(SQL).fetchone()[0]
                SQL = "select WorkshopReservationID from WorkshopParticipantNotification where ConferenceParticipantNotificationID like '{}'".format(pid)
                flag = 0 # enter loop with flag 0 default
                if(cur.execute(SQL).fetchone() is None):
                    SQL = "exec AddWorkshopParticipantNotification '{}', '{}'".format(resid, pid)
                    cnxn.cursor().execute(SQL).commit()
                    with open (writepath, mode) as log:
                        log.write("exec AddWorkshopParticipantNotification '{}', '{}'\n".format(resid, pid))
                    slots = slots - 1
                    continue
                else:
                    testpids = []
                    for row in cur:
                        testpids.append(row[0])
                    for _ in range (len(testpids)):
                        testpid = testpids.pop(0)
                        SQL = "select StartTime from Workshops where WorkshopID like '{}'".format(testpid)
                        starttest=cur.execute(SQL).fetchone()[0]
                        if (starttest<endmain): # we found sth - exit loop with 1 flag
                            flag = 1
                            break;
                if (flag != 1 ): # flag check, if hours collide
                    SQL = "exec AddWorkshopParticipantNotification '{}', '{}'".format(resid, pid)
                    cnxn.cursor().execute(SQL).commit()
                    with open (writepath, mode) as log:
                        log.write("exec AddWorkshopParticipantNotification '{}', '{}'\n".format(resid, pid))
                    slots = slots - 1
                    continue
                else:
                    continue
            else:
                continue
    return;

def AddPayments (cnxn):
    cur = cnxn.cursor()
    SQL = "select ConferenceReservationID from ConferenceReservation where Canceled = 0"
    cur.execute(SQL)
    ids = []
    for row in cur:
        ids.append(row[0])
    for _ in range (len(ids)):
        id = ids.pop(0)
        SQL = "select ReservationDate from ConferenceReservation where ConferenceReservationID = {}".format(id)
        date = parser.parse(cur.execute(SQL).fetchone()[0]).date()
        SQL = "select sum(ReservationPrice) from WorkshopReservation where ConferenceReservationID = {} and Canceled = 0".format(id)
        if(cur.execute(SQL).fetchone()[0] is None):
            amount = 0
        else:
            amount = cur.execute(SQL).fetchone()[0]
        SQL = "select ReservationPrice from ConferenceReservation where ConferenceReservationID = {}".format(id)
        amount = amount+cur.execute(SQL).fetchone()[0]
        date = date+relativedelta(days=random.randint(0,7))
        SQL = "exec AddPayment '{}', '{}', '{}'".format(id, amount, date)
        cnxn.cursor().execute(SQL).commit()
        with open (writepath, mode) as log:
                        log.write("exec AddPayment '{}', '{}', '{}'\n".format(id, amount, date ))
    return;


