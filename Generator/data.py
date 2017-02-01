from faker import Factory
import  random

fake = Factory.create("pl_PL")


class ClientCompany:

    def __init__(self):
        self.CompanyName = fake.company()
        self.City = fake.city()
        self.Address = fake.address()
        self.PostCode = fake.postcode()
        self.Phone = fake.phone_number()
        self.Email = fake.email()
        self.Password = fake.password()

class ClientPrivate:

    def __init__(self):
        self.ClientFirstname = fake.name()
        self.ClientLastname = fake.last_name()
        self.City = fake.city()
        self.Address = fake.address()
        self.PostCode = fake.postcode()
        self.Phone = fake.phone_number()
        self.Email = fake.email()
        self.Password = fake.password()

class Participant:

    def __init__(self):
        self.ParticipantFirstname = fake.name()
        self.ParticipantLastname = fake.last_name()
        self.Email = fake.email()
        self.Password = fake.password()
        self.StudentID = random.choice([fake.unix_time(), 0])

class Conference:

    def __init__(self):
        self.Name = fake.catch_phrase()
        self.Place = fake.city()
        self.Description = random.choice([fake.text(), '0'])

class Workshop:

    def __init__(self):
        self.Title = fake.bs()
        self.Description = random.choice([fake.text(), '0'])
        self.Slots = random.randrange(10, 50, 10)
        self.SlotPrice = random.randrange(0, 30, 5)
