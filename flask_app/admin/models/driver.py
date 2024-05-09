class Driver:
    def __init__(self, Firstname, Lastname, Driver_ID):
        self.Firstname = Firstname
        self.Lastname = Lastname
        self.Driver_ID = Driver_ID


class fullDriver:
    def __init__(self, Firstname, Lastname, Driver_ID, SDT, Wallet, DOB, Gender, Address, CCCD, Driving_license_number, working_experiment):
        self.Firstname = Firstname
        self.Lastname = Lastname
        self.Driver_ID = Driver_ID
        self.SDT = SDT
        self.Wallet = Wallet
        self.DOB = DOB
        self.Gender = Gender
        self.Address = Address
        self.CCCD = CCCD
        self.Driving_license_number = Driving_license_number
        self.working_experiment = working_experiment
    