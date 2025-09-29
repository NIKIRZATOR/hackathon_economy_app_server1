import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_resource_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/resource_item_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserResourceController extends ResourceController {
  AppUserResourceController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<UserResourceModel>(managedContext)
            ..join(object: (r) => r.user)
            ..join(object: (r) => r.resource)
            ..sortBy((r) => r.idUserResource, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения user_resources');
    }
  }

  // GET /user-resource/by-user/:idUser
  @Operation.get('idUser')
  Future<Response> getUserResourcesByUserId(@Bind.path('idUser') int idUser) async {
    try {
      final list = await (Query<UserResourceModel>(managedContext)
            ..where((r) => r.user!.userId).equalTo(idUser)
            ..join(object: (r) => r.resource)
            ..sortBy((r) => r.idUserResource, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения ресурсов пользователя');
    }
  }

  // POST /user-resource
  // body: { "user":{"userId":1}, "resource":{"idItem":2}, "amount":100 }
  @Operation.post()
  Future<Response> create(@Bind.body() UserResourceModel body) async {
    if (body.user?.userId == null || body.resource?.idResource == null) {
      return AppResponse.badRequest(message: 'Нужны user.userId и resource.idItem');
    }
    try {
      final q = Query<UserResourceModel>(managedContext)
        ..values.user = (UserModel()..userId = body.user!.userId)
        ..values.resource = (ResourceItemModel()..idResource = body.resource!.idResource)
        ..values.amount = body.amount ?? 0;
      final created = await q.insert();
      return Response.ok(created);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка добавления записи user_resource');
    }
  }

  // PUT /user-resource   (обновление по userId + resourceId)
  @Operation.put()
  Future<Response> updateByPair(@Bind.body() UserResourceModel body) async {
    final uid = body.user?.userId;
    final rid = body.resource?.idResource;
    if (uid == null || rid == null) {
      return AppResponse.badRequest(message: 'Нужны user.userId и resource.idResource');
    }
    try {
      final exists = await (Query<UserResourceModel>(managedContext)
            ..where((r) => r.user!.userId).equalTo(uid)
            ..where((r) => r.resource!.idResource).equalTo(rid))
          .fetchOne();

      if (exists == null) {
        return AppResponse.badRequest(message: 'Запись user_resource не найдена');
      }

      final updated = await (Query<UserResourceModel>(managedContext)
            ..where((r) => r.idUserResource).equalTo(exists.idUserResource)
            ..values.amount = body.amount ?? exists.amount)
          .updateOne();

      return updated == null
          ? AppResponse.serverError(null, message: 'Не удалось обновить')
          : AppResponse.ok(message: 'Обновлено');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления user_resource');
    }
  }

  // DELETE /user-resource/:idUserResource
  @Operation.delete('idUserResource')
  Future<Response> delete(@Bind.path('idUserResource') int id) async {
    try {
      final n = await (Query<UserResourceModel>(managedContext)
            ..where((r) => r.idUserResource).equalTo(id))
          .delete();
      return n == 0 ? AppResponse.badRequest(message: 'Не найдено') : AppResponse.ok(message: 'Удалено');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка удаления user_resource');
    }
  }
}
