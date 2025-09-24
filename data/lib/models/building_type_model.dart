import 'package:conduit_core/conduit_core.dart';

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
}
