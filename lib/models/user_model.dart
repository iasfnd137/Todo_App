class UserModel {
  final String uid;
  final String name;
  final String email;
  late final String? profileImage;
  final int dt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    required this.dt,
  });

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      dt: map['dt'],
    );
  }
}