class Account{
  final String id;
  final String username;
  final String email;

  Account({required this.id, required this.username, required this.email});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      id: json['id'],
      username: json['username'],
      email: json['email']
  );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email
    };
  }

}