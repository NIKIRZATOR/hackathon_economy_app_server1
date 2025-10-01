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

  @Operation.put()
  Future<Response> upsertByPair(@Bind.body() Map<String, dynamic> body) async {
    try {
      final userId = body['user']?['userId'] as int?;
      final resId  = body['resource']?['idResource'] as int?;
      final amountRaw = body['amount'];
      if (userId == null || resId == null || amountRaw == null) {
        return AppResponse.badRequest(message: 'Нужны user.userId, resource.idResource, amount');
      }
      final amount = (amountRaw is int) ? amountRaw.toDouble() : (amountRaw as num).toDouble();

      // ищем по (user, resource)
      final existed = await (Query<UserResourceModel>(managedContext)
            ..where((ur) => ur.user!.userId).equalTo(userId)
            ..where((ur) => ur.resource!.idResource).equalTo(resId))
          .fetchOne();

      if (existed != null) {
        final q = Query<UserResourceModel>(managedContext)
          ..where((ur) => ur.idUserResource).equalTo(existed.idUserResource!)
          ..values.amount = amount;
        final updated = await q.updateOne() ?? existed;
        return Response.ok({
          'idUserResource': updated.idUserResource,
          'userId': updated.user?.userId,
          'idResource': updated.resource?.idResource,
          'amount': updated.amount,
        });
      }

      // нет — создаём
      final ins = await (Query<UserResourceModel>(managedContext)
            ..values.user = (UserModel()..userId = userId)
            ..values.resource = (ResourceItemModel()..idResource = resId)
            ..values.amount = amount)
          .insert();

      return Response.ok({
        'idUserResource': ins.idUserResource,
        'userId': ins.user?.userId,
        'idResource': ins.resource?.idResource,
        'amount': ins.amount,
      });
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка upsert user_resource');
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
