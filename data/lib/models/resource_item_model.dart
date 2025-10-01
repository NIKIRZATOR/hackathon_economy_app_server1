import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_input_model.dart';
import 'package:data/models/building_type_output_model.dart';
import 'package:data/models/user_building_progress_model.dart';
import 'package:data/models/user_resource_model.dart';

class ResourceItemModel extends ManagedObject<_ResourceItemModel>
    implements _ResourceItemModel {}

class _ResourceItemModel {
  @primaryKey
  int? idResource;

  @Column(nullable: false)
  String? title;

  @Column(nullable: false)
  double? resourceCost;

  @Column(unique: true, indexed: true)
  String? code;

  @Column(nullable: false, defaultValue: 'false')
  bool? isCurrency;

  @Column(nullable: false, defaultValue: 'true')
  bool? isStorable;

  @Column(nullable: true)
  String? imagePath;

  ManagedSet<UserResourceModel>? usages; // где используется (UserResourceModel)

  ManagedSet<BuildingTypeInputModel>? asInput;
  ManagedSet<BuildingTypeOutputModel>? asOutput;

  ManagedSet<UserBuildingProgressModel>? asInputInProgress;
  ManagedSet<UserBuildingProgressModel>? asOutputInProgress;
}
