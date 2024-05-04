// ignore_for_file: non_constant_identifier_names

class User{
  final String firstname;
  final String lastname;
  final String SDT;
  final int Wallet;
  final String DOB;
  final String gender;
  final String Address;
  final String CCCD;

  User({required this.firstname,required this.lastname,required this.SDT,required this.Wallet,required this.DOB,required this.gender,required this.Address,required this.CCCD});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'],
      lastname: json['lastname'],
      SDT: json['SDT'],
      Wallet: json['Wallet'],
      DOB: json['DOB'],
      gender: json['gender'],
      Address: json['Address'],
      CCCD: json['CCCD'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'SDT': SDT,
      'Wallet': Wallet,
      'DOB': DOB,
      'gender': gender,
      'Address': Address,
      'CCCD': CCCD,
    };
  }


}