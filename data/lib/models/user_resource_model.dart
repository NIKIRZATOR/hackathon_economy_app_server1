import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/resource_item_model.dart';

class UserResourceModel extends ManagedObject<_UserResourceModel>
    implements _UserResourceModel {}

class _UserResourceModel {
  @primaryKey
  int? idUserResource;

  // FK user_model.user_id
  @Relate(#resources, isRequired: true, onDelete: DeleteRule.cascade)
  UserModel? user;

  // FK resource_items.id_item
  @Relate(#usages, isRequired: true, onDelete: DeleteRule.cascade)
  ResourceItemModel? resource;

  @Column(nullable: false)
  double? amount;
}
