import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserController extends ResourceController {
  AppUserController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<UserModel>(managedContext)
            ..sortBy((u) => u.userId, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения пользователей');
    }
  }

  @Operation.get('idUser')
  Future<Response> getById(@Bind.path('idUser') int id) async {
    try {
      final item = await (Query<UserModel>(managedContext)
            ..where((u) => u.userId).equalTo(id))
          .fetchOne();
      return item == null ? AppResponse.badRequest(message: 'Не найден') : Response.ok(item);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения пользователя');
    }
  }

  @Operation.put('idUser')
  Future<Response> update(
    @Bind.path('idUser') int id,
    @Bind.body() UserModel body,
  ) async {
    try {
      final exists = await managedContext.fetchObjectWithID<UserModel>(id);
      if (exists == null) return AppResponse.badRequest(message: 'Не найден');

      final q = Query<UserModel>(managedContext)
        ..where((u) => u.userId).equalTo(id)
        ..values.userLvl = body.userLvl ?? exists.userLvl
        ..values.userXp = body.userXp ?? exists.userXp
        ..values.lastClaimAt = body.lastClaimAt ?? exists.lastClaimAt;


      final updated = await q.updateOne();
      if (updated == null) {
        return AppResponse.serverError(null, message: 'Обновление не выполнено');
      }
      return AppResponse.ok(message: 'Профиль обновлён');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления');
    }
  }
}
