import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_building_model.dart';
import 'package:data/models/resource_item_model.dart';

class UserBuildingProgressModel
    extends ManagedObject<_UserBuildingProgressModel>
    implements _UserBuildingProgressModel {}

class _UserBuildingProgressModel {
  @primaryKey
  int? idProgress;

  // одна запись = один запущенный рецепт
  @Relate(#progresses, isRequired: true, onDelete: DeleteRule.cascade)
  UserBuildingModel? userBuilding;

  // ресурс на входе 
  @Relate(#asInputInProgress, isRequired: true, onDelete: DeleteRule.restrict)
  ResourceItemModel? resourceIn;

  // ресурс на выход
  @Relate(#asOutputInProgress, isRequired: true, onDelete: DeleteRule.restrict)
  ResourceItemModel? resourceOut;

  @Column(nullable: false) // длительность одного цикла (сек)
  int? cycleDurationSec;

  @Column(nullable: false) // вход за цикл (обычно 1)
  double? inPerCycle;

  @Column(nullable: false) // выход за цикл (например, 5 монет)
  double? outPerCycle;

  @Column(nullable: false)// сколько положили на старте
  int? totalToProcess;

  @Column(nullable: false, defaultValue: '0')
  int? processedCount; // сколько циклов клиент завершил

  @Column(nullable: false, defaultValue: '0')
  double? readyOut; // накопленный результат

  @Column(nullable: false)
  DateTime? startedAtClient; // когда клиент начал

  @Column(nullable: false)
  DateTime? startedAtServer; // когда сервер принял старт

  @Column(nullable: false, defaultValue: 'now()')
  DateTime? updatedAt; // серверный updated

  @Column(nullable: false, defaultValue: "'running'")
  String? state; // running | ready | collected | cancelled
}
