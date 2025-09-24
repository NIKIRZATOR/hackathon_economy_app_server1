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
  Future<Response> getUserBuildingsByUserId(@Bind.path('idUser') int idUser) async {
    try {
      final list = await (Query<UserBuildingModel>(managedContext)
            ..where((b) => b.user!.userId).equalTo(idUser)
            ..join(object: (b) => b.buildingType)
            ..sortBy((b) => b.idUserBuilding, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения построек пользователя');
    }
  }

  // POST /user-building
  // body: { "user":{"userId":1}, "buildingType":{"idBuilding":3}, "x":10,"y":5,"currentLevel":1,"state":"placed" }
  @Operation.post()
  Future<Response> create(@Bind.body() UserBuildingModel body) async {
    if (body.user?.userId == null || body.buildingType?.idBuildingType == null || body.x == null || body.y == null) {
      return AppResponse.badRequest(message: 'Нужны user.userId, buildingType.idBuilding, x, y');
    }
    try {
      final q = Query<UserBuildingModel>(managedContext)
        ..values.user = (UserModel()..userId = body.user!.userId)
        ..values.buildingType = (BuildingTypeModel()..idBuildingType = body.buildingType!.idBuildingType)
        ..values.x = body.x
        ..values.y = body.y
        ..values.currentLevel = body.currentLevel ?? 1
        ..values.state = body.state ?? 'placed'
        ..values.placedAt = body.placedAt ?? DateTime.now()
        ..values.lastUpgradeAt = body.lastUpgradeAt;
      final created = await q.insert();
      return Response.ok(created);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка добавления user_building');
    }
  }

  // PUT /user-building/:idUserBuilding
  @Operation.put('idUserBuilding')
  Future<Response> update(
    @Bind.path('idUserBuilding') int id,
    @Bind.body() UserBuildingModel body,
  ) async {
    try {
      final exists = await managedContext.fetchObjectWithID<UserBuildingModel>(id);
      if (exists == null) return AppResponse.badRequest(message: 'Не найдено');

      final q = Query<UserBuildingModel>(managedContext)
        ..where((b) => b.idUserBuilding).equalTo(id)
        ..values.x = body.x ?? exists.x
        ..values.y = body.y ?? exists.y
        ..values.currentLevel = body.currentLevel ?? exists.currentLevel
        ..values.state = body.state ?? exists.state
        ..values.placedAt = body.placedAt ?? exists.placedAt
        ..values.lastUpgradeAt = body.lastUpgradeAt ?? exists.lastUpgradeAt;

      final updated = await q.updateOne();
      return updated == null
          ? AppResponse.serverError(null, message: 'Не удалось обновить')
          : AppResponse.ok(message: 'Обновлено');
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
