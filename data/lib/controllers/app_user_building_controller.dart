import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_building_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/building_type_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserBuildingController extends ResourceController {
  AppUserBuildingController(this.managedContext);
  final ManagedContext managedContext;

  // GET /user-building
  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<UserBuildingModel>(managedContext)
            ..join(object: (b) => b.user)
            ..join(object: (b) => b.buildingType)
            ..sortBy((b) => b.idUserBuilding, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения user_buildings');
    }
  }

  // GET /user-building/by-user/:idUser
  @Operation.get('idUser')
  Future<Response> getUserBuildingsByUserId(
    @Bind.path('idUser') int idUser) async {
    try {
      final list = await (Query<UserBuildingModel>(managedContext)
            ..where((b) => b.user!.userId).equalTo(idUser)
            ..join(object: (b) => b.buildingType)
            ..sortBy((b) => b.idUserBuilding, QuerySortOrder.ascending))
          .fetch();

      final flat = list.map(ubToFlat).toList();
      return flat.isEmpty ? Response.notFound() : Response.ok(flat);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения построек пользователя');
    }
  }

  @Operation.post()
  Future<Response> createOrUpsert(@Bind.body() UserBuildingModel body) async {
    try {
      final userId = body.user?.userId;
      final btId   = body.buildingType?.idBuildingType;
      final cid    = body.clientId;

      if (userId == null || btId == null || cid == null || cid.isEmpty || body.x == null || body.y == null) {
        return AppResponse.badRequest(message: 'Нужны user.userId, buildingType.idBuildingType, clientId, x, y');
      }

      // ищем по (user, clientId)
      final existed = await (Query<UserBuildingModel>(managedContext)
            ..where((b) => b.user!.userId).equalTo(userId)
            ..where((b) => b.clientId).equalTo(cid))
          .fetchOne();

      if (existed != null) {
        final q = Query<UserBuildingModel>(managedContext)
          ..where((b) => b.idUserBuilding).equalTo(existed.idUserBuilding!)
          ..values
          ..values.buildingType = (BuildingTypeModel()..idBuildingType = btId)
          ..values.x = body.x ?? existed.x
          ..values.y = body.y ?? existed.y
          ..values.currentLevel = body.currentLevel ?? existed.currentLevel
          ..values.state = body.state ?? existed.state
          ..values.placedAt = body.placedAt ?? existed.placedAt
          ..values.lastUpgradeAt = body.lastUpgradeAt ?? existed.lastUpgradeAt;
        final updated = await q.updateOne();
        return Response.ok(ubToFlat(updated ?? existed));
      }

      final ins = await (Query<UserBuildingModel>(managedContext)
            ..values.user = (UserModel()..userId = userId)
            ..values.buildingType = (BuildingTypeModel()..idBuildingType = btId)
            ..values.clientId = cid
            ..values.x = body.x
            ..values.y = body.y
            ..values.currentLevel = body.currentLevel ?? 1
            ..values.state = body.state ?? 'placed'
            ..values.placedAt = body.placedAt ?? DateTime.now().toUtc()
            ..values.lastUpgradeAt = body.lastUpgradeAt)
          .insert();

      return Response.ok(ubToFlat(ins));
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка добавления/склейки user_building');
    }
  }

    Map<String, dynamic> ubToFlat(UserBuildingModel m) => {
    'idUserBuilding': m.idUserBuilding,
    'idUser': m.user?.userId,
    'idBuildingType': m.buildingType?.idBuildingType,
    'x': m.x,
    'y': m.y,
    'currentLevel': m.currentLevel,
    'state': m.state,
    'placedAt': m.placedAt?.toUtc().toIso8601String(),
    'lastUpgradeAt': m.lastUpgradeAt?.toUtc().toIso8601String(),
    'client_id': m.clientId,
  };

  // PUT /user-building/:idUserBuilding
 @Operation.put('idUserBuilding')
  Future<Response> update(
    @Bind.path('idUserBuilding') int id,
    @Bind.body() UserBuildingModel body,
  ) async {
    try {
      // если юзера берёшь из токена — возьми оттуда; тут у тебя приходит в body
      final userId = body.user?.userId;

      final exists = await (Query<UserBuildingModel>(managedContext)
            ..where((b) => b.idUserBuilding).equalTo(id)
            ..where((b) => b.user!.userId).equalTo(userId ?? (await managedContext.fetchObjectWithID<UserBuildingModel>(id))?.user?.userId ?? -1))
          .fetchOne();

      if (exists == null) return AppResponse.badRequest(message: 'Не найдено или чужая запись');

      final q = Query<UserBuildingModel>(managedContext)
        ..where((b) => b.idUserBuilding).equalTo(id)
        ..values
        ..values.x = body.x ?? exists.x
        ..values.y = body.y ?? exists.y
        ..values.currentLevel = body.currentLevel ?? exists.currentLevel
        ..values.state = body.state ?? exists.state
        ..values.placedAt = body.placedAt ?? exists.placedAt
        ..values.lastUpgradeAt = body.lastUpgradeAt ?? exists.lastUpgradeAt;

      final updated = await q.updateOne();
      return Response.ok(ubToFlat(updated ?? exists));
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления user_building');
    }
}

  // DELETE /user-building/:idUserBuilding
  @Operation.delete('idUserBuilding')
  Future<Response> delete(@Bind.path('idUserBuilding') int id) async {
    try {
      final n = await (Query<UserBuildingModel>(managedContext)
            ..where((b) => b.idUserBuilding).equalTo(id))
          .delete();
      return n == 0 ? AppResponse.badRequest(message: 'Не найдено') : AppResponse.ok(message: 'Удалено');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка удаления user_building');
    }
  }
}
