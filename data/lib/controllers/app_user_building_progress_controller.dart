import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_building_model.dart';
import 'package:data/models/resource_item_model.dart';
import 'package:data/models/user_building_progress_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserBuildingProgressController extends ResourceController {
  AppUserBuildingProgressController(this.managedContext);
  final ManagedContext managedContext;

  // GET /user-building-progress
  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<UserBuildingProgressModel>(managedContext)
            ..join(object: (p) => p.userBuilding)
            ..join(object: (p) => p.resourceIn)
            ..join(object: (p) => p.resourceOut)
            ..sortBy((p) => p.idProgress, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения user_building_progress');
    }
  }

  // GET /user-building-progress/by-user/:idUser
  @Operation.get('idUser')
  Future<Response> getByUser(
    @Bind.path('idUser') int idUser) async {
    try {
      final list = await (Query<UserBuildingProgressModel>(managedContext)
            ..join(object: (p) => p.userBuilding)
                .where((ub) => ub.user!.userId).equalTo(idUser)
            ..join(object: (p) => p.resourceIn)
            ..join(object: (p) => p.resourceOut)
            ..sortBy((p) => p.idProgress, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения прогрессов по пользователю');
    }
  }

  // GET /user-building-progress/:idProgress
  @Operation.get('idProgress')
  Future<Response> getOne(
    @Bind.path('idProgress') int idProgress) async {
    try {
      final item = await (Query<UserBuildingProgressModel>(managedContext)
            ..where((p) => p.idProgress).equalTo(idProgress)
            ..join(object: (p) => p.userBuilding)
            ..join(object: (p) => p.resourceIn)
            ..join(object: (p) => p.resourceOut))
          .fetchOne();
      return item == null ? Response.notFound() : Response.ok(item);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения прогресса');
    }
  }

  // POST /user-building-progress
  @Operation.post()
  Future<Response> create(@Bind.body() UserBuildingProgressModel body) async {
    final ubId   = body.userBuilding?.idUserBuilding;
    final rinId  = body.resourceIn?.idResource;
    final routId = body.resourceOut?.idResource;
    final dur    = body.cycleDurationSec;
    final inPer  = body.inPerCycle;
    final outPer = body.outPerCycle;
    final total  = body.totalToProcess;
    final startedAtClient = body.startedAtClient;

    if ([ubId, rinId, routId, 
      dur, inPer, outPer, total, 
      startedAtClient].contains(null)) {
        return AppResponse.badRequest(
          message: 'Нужны: userBuilding.idUserBuilding, resourceIn.idResource, resourceOut.idResource, '
                  'cycleDurationSec, inPerCycle, outPerCycle, totalToProcess, startedAtClient');
    }

    try {
      final created = await (Query<UserBuildingProgressModel>(managedContext)
            ..values.userBuilding = (UserBuildingModel()..idUserBuilding = ubId)
            ..values.resourceIn   = (ResourceItemModel()..idResource = rinId)
            ..values.resourceOut  = (ResourceItemModel()..idResource = routId)
            ..values.cycleDurationSec = dur
            ..values.inPerCycle   = inPer
            ..values.outPerCycle  = outPer
            ..values.totalToProcess = total
            ..values.processedCount = body.processedCount ?? 0
            ..values.readyOut       = body.readyOut ?? 0
            ..values.startedAtClient = startedAtClient!.toUtc()
            ..values.startedAtServer = DateTime.now().toUtc()
            ..values.updatedAt       = DateTime.now().toUtc()
            ..values.state = body.state ?? 'running')
          .insert();

      return Response.ok(created);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка добавления user_building_progress');
    }
  }

  // PUT /user-building-progress/:idProgress
  // обновляем только статус прогресса: processedCount, readyOut, state, updatedAt
  @Operation.put('idProgress')
  Future<Response> update(
    @Bind.path('idProgress') int idProgress,
    @Bind.body() UserBuildingProgressModel body,
  ) async {
    try {
      final exists = await managedContext.fetchObjectWithID<UserBuildingProgressModel>(idProgress);
      if (exists == null) return AppResponse.badRequest(message: 'Не найдено');

      int? processed = body.processedCount ?? exists.processedCount;
      if (processed != null && exists.totalToProcess != null) {
        final now = DateTime.now().toUtc();
        final maxByTime = ((now.difference(exists.startedAtServer!).inSeconds) / exists.cycleDurationSec!).floor();
        processed = processed.clamp(0, exists.totalToProcess!).clamp(0, maxByTime);
      }

      final updated = await (Query<UserBuildingProgressModel>(managedContext)
            ..where((p) => p.idProgress).equalTo(idProgress)
            ..values.processedCount = processed
            ..values.readyOut = body.readyOut ??
                (processed != null && exists.outPerCycle != null
                    ? processed * exists.outPerCycle!
                    : exists.readyOut)
            ..values.state = body.state ?? exists.state
            ..values.updatedAt = DateTime.now().toUtc())
          .updateOne();

      return updated == null
          ? AppResponse.serverError(null, message: 'Не удалось обновить')
          : AppResponse.ok(message: 'Обновлено');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления user_building_progress');
    }
  }

  // DELETE /user-building-progress/:idProgress
  @Operation.delete('idProgress')
  Future<Response> delete(@Bind.path('idProgress') int idProgress) async {
    try {
      final n = await (Query<UserBuildingProgressModel>(managedContext)
            ..where((p) => p.idProgress).equalTo(idProgress))
          .delete();
      return n == 0 ? AppResponse.badRequest(message: 'Не найдено') : AppResponse.ok(message: 'Удалено');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка удаления user_building_progress');
    }
  }
}
