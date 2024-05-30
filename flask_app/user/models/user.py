class User:
    def __init__(self, user_id, firstname, lastname, sdt, wallet, dob, gender, address, cccd):
        self.user_id = user_id
        self.firstname = firstname
        self.lastname = lastname
        self.sdt = sdt
        self.wallet = wallet
        self.dob = dob
        self.gender = gender
        self.address = address
        self.cccd = cccd
       
    @staticmethod
    def from_dict(source):
        print("Data received for User:", source)
        # Convert from dictionary to User object
        user = User(
        user_id=source.get('User_ID'),
        firstname=source.get('firstname'),
        lastname=source.get('lastname'),
        sdt=source.get('SDT'),
        wallet=source.get('Wallet'),
        dob=source.get('DOB'),
        gender=source.get('gender'),
        address=source.get('Address'),
        cccd=source.get('CCCD'),
        
        )
        print(f"Created user object: {user}")
        return user