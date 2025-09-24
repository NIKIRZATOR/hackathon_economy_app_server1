import 'package:conduit_core/conduit_core.dart';

class UserModel extends ManagedObject<_UserModel> implements _UserModel {
  // виртуальное поле: прилетает в запросе, в ответ не уходит
  @Serialize(input: true, output: false)
  String? password;
}

class _UserModel {
  @primaryKey
  int? userId;

  @Column(unique: true, indexed: true)
  String? username;

  @Column(nullable: false)  
  String? cityTitle;

  @Column(defaultValue: '1')
  int? userLvl;

  @Column(defaultValue: '0')
  int? userXp;

  @Column(nullable: true)
  DateTime? lastClaimAt;

  // храним только хеш пароля
  @Column(omitByDefault: true) 
  String? passwordHash;
}
