// lib/data/models/user_tasks_done_model.dart
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';

class UserTasksDoneModel extends ManagedObject<_UserTasksDoneModel>
    implements _UserTasksDoneModel {}

class _UserTasksDoneModel {
  @primaryKey
  int? idUserTasksDone;

  @Relate(#tasksDone, isRequired: true, onDelete: DeleteRule.cascade)
  UserModel? user;

  // JSONB: массив строк ID задач, как в localStorage ["L1_5","L1_2"]
  @Column(nullable: false, databaseType: ManagedPropertyType.document)
  Document? done;

  @Column(nullable: false, indexed: true)
  DateTime? updatedAt;
}
