
class Artist{

  String bankId;
  String bankNumber;
  String email;
  String name;
  String password;
  String phoneNumber;


  Artist.fromMap(Map<String, dynamic> json)
      : bankId = json['bankId'],
        bankNumber = json['bankNumber'],
        email = json['email'],
        name = json['name'],
        password = json['password'],
        phoneNumber = json['language'];


}