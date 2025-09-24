import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_input_model.dart';
import 'package:data/models/building_type_output_model.dart';
import 'package:data/models/user_building_model.dart';

class BuildingTypeModel extends ManagedObject<_BuildingTypeModel>
    implements _BuildingTypeModel {}

class _BuildingTypeModel {
  @primaryKey
  int? idBuildingType;

  @Column(nullable: false)
  String? titleBuildingType;

  @Column(nullable: true)
  String? description;

  @Column(nullable: false)
  int? hSize;

  @Column(nullable: false)
  int? wSize;

  @Column(nullable: false)
  int? unlockLevel;

  @Column(nullable: false)
  int? maxUpgradeLvl;

  @Column(nullable: true)
  String? imagePath;

  ManagedSet<UserBuildingModel>? userBuildings; // кто использует (UserBuildingModel)

  ManagedSet<BuildingTypeInputModel>? inputs;
  ManagedSet<BuildingTypeOutputModel>? outputs;

}
