class User {
  final String Firstname;
  final String Lastname;
  final String User_ID;

  User(this.Firstname, this.Lastname, this.User_ID);
}

class FullUser {
  final String Firstname;
  final String Lastname;
  final String User_ID;
  final String SDT;
  final String Wallet;
  final String DOB;
  final String Gender;
  final String Address;
  final String CCCD;
  final String created_at;

  FullUser(this.Firstname, this.Lastname, this.User_ID, this.SDT, this.Wallet,
      this.DOB, this.Gender, this.Address, this.CCCD, this.created_at);
}
