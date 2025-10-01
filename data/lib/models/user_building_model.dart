import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_building_progress_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/building_type_model.dart';

class UserBuildingModel extends ManagedObject<_UserBuildingModel>
    implements _UserBuildingModel {}

class _UserBuildingModel {
  @primaryKey
  int? idUserBuilding;

  // FK user_model.user_id
  @Relate(#buildings, isRequired: true, onDelete: DeleteRule.cascade)
  UserModel? user;

  // FK building_type.id_building
  @Relate(#userBuildings, isRequired: true, onDelete: DeleteRule.cascade)
  BuildingTypeModel? buildingType;

  @Column(nullable: false) int? x;
  @Column(nullable: false) int? y;

  @Column(nullable: false, defaultValue: '1')
  int? currentLevel;

  // состояние (placed/moving/disabled) — 
  @Column(nullable: false, defaultValue: "'placed'")
  String? state;

  @Column(nullable: true) DateTime? placedAt;
  @Column(nullable: true) DateTime? lastUpgradeAt;

  ManagedSet<UserBuildingProgressModel>? progresses;
}
