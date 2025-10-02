import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_building_model.dart';
import 'package:data/models/user_resource_model.dart';
import 'package:data/models/user_task_model.dart';

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

  ManagedSet<UserResourceModel>? resources; // склад пользователя
  ManagedSet<UserBuildingModel>? buildings; // постройки
  ManagedSet<UserTasksDoneModel>? tasksDone; // выполненные задания
}
