import 'dart:js_interop';

class User{
  final String firstname;
  final String lastname;
  final String email;
  final String SDT;
  final int Wallet;
  final DateTime DOB;
  final String gender;
  final String Address;
  final String CCCD;

  User({required this.firstname,required this.lastname,required this.email,required this.SDT,required this.Wallet,required this.DOB,required this.gender,required this.Address,required this.CCCD});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      SDT: json['SDT'],
      Wallet: json['Wallet'],
      DOB: DateTime.parse(json['DOB']),
      gender: json['gender'],
      Address: json['Address'],
      CCCD: json['CCCD'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'SDT': SDT,
      'Wallet': Wallet,
      'DOB': DOB.toIso8601String(),
      'gender': gender,
      'Address': Address,
      'CCCD': CCCD,
    };
  }


}