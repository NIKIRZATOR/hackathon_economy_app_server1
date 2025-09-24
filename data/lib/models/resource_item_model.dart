import 'package:conduit_core/conduit_core.dart';

class ResourceItemModel extends ManagedObject<_ResourceItemModel>
    implements _ResourceItemModel {}

class _ResourceItemModel {
  @primaryKey
  int? idResourceItem;

  @Column(nullable: false)
  String? title;

  @Column(unique: true, indexed: true)
  String? code;

  @Column(nullable: false, defaultValue: 'false')
  bool? isCurrency;

  @Column(nullable: false, defaultValue: 'true')
  bool? isStorable;
}
