class AppUser{
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name
  }); 

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'email': email,
      'name': name
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
  return AppUser(
    uid: map['uid'],
    email: map['email'],
    name: map['name'],
  );
}


}