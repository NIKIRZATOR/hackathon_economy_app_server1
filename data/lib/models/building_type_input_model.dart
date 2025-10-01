import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_model.dart';
import 'package:data/models/resource_item_model.dart';

class BuildingTypeInputModel extends ManagedObject<_BuildingTypeInputModel>
    implements _BuildingTypeInputModel {}

class _BuildingTypeInputModel {
  @primaryKey
  int? idBuildingTypeInput;

  // FK building_type.id_building  (столбец id_building_type)
  @Relate(#inputs, isRequired: true, onDelete: DeleteRule.cascade)
  BuildingTypeModel? buildingType;

  // FK resource_items.id_item  (столбец id_resource)
  @Relate(#asInput, isRequired: true, onDelete: DeleteRule.cascade)
  ResourceItemModel? resource;

  @Column(nullable: true)
  String? consumeMode; //per_sec | per_cycle

  @Column(nullable: true) // сколько единиц входного ресурса тратится за один цикл
  double? consumePerCycle;

  @Column(nullable: true) // длительность цикла в секундах, если consumemode == per_cycle
  int? cycleDuration; 

  @Column( nullable: true) // ёмкость входного буфера
  int? bufferForResource; 

  @Column(nullable: true)
  double? consumePerSec;

  @Column(nullable: true)
  double? amountPerSec;
}
