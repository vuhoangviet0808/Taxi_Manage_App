class Account{
  final String SDT;
  final String password;
  final String role;
  final String status;

  Account({required this.SDT, required this.password, required this.role, required this.status});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      SDT: json["SDT"],
      password: json["password"],
      role: json["role"],
      status: json["status"]
  );
  }
  Map<String, dynamic> toJson() {
    return {
      'SDT': SDT,
      'password': password,
      'role': role,
      'status': status
    };
  }

}