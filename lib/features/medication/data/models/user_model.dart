import 'package:hive/hive.dart';
import '../../../auth/domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 20)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String name;

  UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromEntity(User user) {
    return UserModel(id: user.id, email: user.email, name: user.name);
  }

  User toEntity() {
    return User(id: id, email: email, name: name);
  }
}
