// lib/data/controllers/app_user_tasks_done_controller.dart
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_task_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserTasksDoneController extends ResourceController {
  AppUserTasksDoneController(this.managedContext);
  final ManagedContext managedContext;

  // GET /user-tasks-done/:idUser
  @Operation.get('idUser')
  Future<Response> getByUser(
    @Bind.path('idUser') int idUser,
  ) async {
    try {
      final rec = await (Query<UserTasksDoneModel>(managedContext)
            ..where((r) => r.user!.userId).equalTo(idUser))
          .fetchOne();

      if (rec == null) {
        return Response.ok({
          'userId': idUser,
          'tasks': <String>[],
          'updatedAt': null,
        });
      }

      final list = (rec.done?.data ?? []) as List<dynamic>;
      final tasks = list.map((e) => '$e').toList();

      return Response.ok({
        'userId': idUser,
        'tasks': tasks,
        'updatedAt': rec.updatedAt?.toUtc().toIso8601String(),
      });
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения задач пользователя');
    }
  }

  // POST /user-tasks-done/:idUser
  // body: { "tasks": ["L1_5","L1_2"] }
  @Operation.post('idUser')
  Future<Response> syncAll(
    @Bind.path('idUser') int idUser,
    @Bind.body() Map<String, dynamic> body,
  ) async {
    try {
      final tasks = body['tasks'] as List<dynamic>?;
      if (tasks == null) {
        return AppResponse.badRequest(message: 'Нужно поле tasks: List<String>');
      }

      // храним как массив строк
      final tasksStr = tasks.map((e) => '$e').toList();
      final now = DateTime.now().toUtc();

      // upsert по userId (заменяем запись ТОЛЬКО для этого пользователя)
      final existed = await (Query<UserTasksDoneModel>(managedContext)
            ..where((r) => r.user!.userId).equalTo(idUser))
          .fetchOne();

      if (existed == null) {
        final created = await (Query<UserTasksDoneModel>(managedContext)
              ..values.user = (UserModel()..userId = idUser)
              ..values.done = Document(tasksStr)
              ..values.updatedAt = now)
            .insert();

        return Response.ok({
          'userId': idUser,
          'tasks': tasksStr,
          'updatedAt': created.updatedAt?.toUtc().toIso8601String(),
        });
      } else {
        final updated = await (Query<UserTasksDoneModel>(managedContext)
              ..where((r) => r.idUserTasksDone).equalTo(existed.idUserTasksDone)
              ..values.done = Document(tasksStr)
              ..values.updatedAt = now)
            .updateOne();

        final rec = updated ?? existed;
        final list = (rec.done?.data ?? []) as List<dynamic>;

        return Response.ok({
          'userId': idUser,
          'tasks': list.map((e) => '$e').toList(),
          'updatedAt': rec.updatedAt?.toUtc().toIso8601String(),
        });
      }
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка синхронизации задач');
    }
  }
}
