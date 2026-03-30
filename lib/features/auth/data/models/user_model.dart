import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel extends User {
  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  String get email => super.email;

  @override
  @HiveField(2)
  String get name => super.name;

  @HiveField(3)
  final String password;

  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required this.password,
  });

  factory UserModel.fromFirebase(dynamic firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
      password: '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'password': password};
  }

  Map<String, dynamic> toFirestore() {
    return {'id': id, 'email': email, 'name': name};
  }

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: '',
    );
  }
}
