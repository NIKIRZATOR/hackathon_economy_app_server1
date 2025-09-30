import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_model.dart';
import 'package:data/models/resource_item_model.dart';

class BuildingTypeOutputModel extends ManagedObject<_BuildingTypeOutputModel>
    implements _BuildingTypeOutputModel {}

class _BuildingTypeOutputModel {
  @primaryKey
  int? idBuildingTypeOutput;

  // FK building_type.id_building  (столбец id_building_type)
  @Relate(#outputs, isRequired: true, onDelete: DeleteRule.cascade)
  BuildingTypeModel? buildingType;

  // FK resource_items.id_item  (столбец id_resource)
  @Relate(#asOutput, isRequired: true, onDelete: DeleteRule.cascade)
  ResourceItemModel? resource;

  @Column(nullable: true)
  String? produceMode; // per_sec | per_cycle

  @Column(nullable: true)
  double? producePerSec;

  @Column(nullable: true)
  int? cycleDuration;

  @Column(nullable: true)
  double? amountPerCycle;

  @Column( nullable: true)
  int? bufferForResource;
}
