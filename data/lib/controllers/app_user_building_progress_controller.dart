import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/resource_item_model.dart';
import 'package:data/models/user_building_model.dart';
import 'package:data/models/user_building_progress_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserBuildingProgressController extends ResourceController {
  AppUserBuildingProgressController(this.ctx);
  final ManagedContext ctx;

  @Operation.post('action')
  Future<Response> postAction(
    @Bind.path('action') String action, 
    @Bind.body() Map<String, dynamic> body) async {
    switch (action) {
      case 'start': return _start(body);
      case 'sync':  return _syncList(body);
      case 'collect': return _collect(body);
      default: return AppResponse.badRequest(message: 'unknown action');
    }
  }

  Future<Response> _start(Map<String, dynamic> b) async {
    final ubId = b['userBuilding']?['idUserBuilding'] as int?;
    final rin  = b['resourceIn']?['idResource'] as int?;
    final rout = b['resourceOut']?['idResource'] as int?;
    final total = b['totalToProcess'] as int?;
    final dur   = b['cycleDurationSec'] as int?;
    final inPer = (b['inPerCycle'] as num?)?.toDouble();
    final outPer= (b['outPerCycle'] as num?)?.toDouble();
    final startedAtClient = DateTime.parse(b['startedAtClient'] as String);

    // TODO: проверить ресурсы пользователя, вместимость и т.д., списать входной ресурс

    final created = await (Query<UserBuildingProgressModel>(ctx)
          ..values.userBuilding = (UserBuildingModel()..idUserBuilding = ubId)
          ..values.resourceIn   = (ResourceItemModel()..idResource = rin)
          ..values.resourceOut  = (ResourceItemModel()..idResource = rout)
          ..values.totalToProcess = total
          ..values.cycleDurationSec = dur
          ..values.inPerCycle = inPer
          ..values.outPerCycle = outPer
          ..values.processedCount = 0
          ..values.readyOut = 0
          ..values.startedAtClient = startedAtClient.toUtc()
          ..values.startedAtServer = DateTime.now().toUtc()
          ..values.state = 'running')
        .insert();

    return Response.ok(created);
  }

  Future<Response> _syncList(dynamic body) async {
    if (body is! List) return AppResponse.badRequest(message: 'array required');
    final now = DateTime.now().toUtc();
    final updated = <UserBuildingProgressModel>[];

    for (final raw in body.cast<Map<String, dynamic>>()) {
      final id = raw['idProgress'] as int;
      final snapProcessed = (raw['processedCount'] as int?) ?? 0;

      final p = await (Query<UserBuildingProgressModel>(ctx)
            ..where((x) => x.idProgress).equalTo(id))
          .fetchOne();
      if (p == null) continue;

      final maxPossible = ((now.difference(p.startedAtServer!).inSeconds) / p.cycleDurationSec!).floor();
      final clampedProcessed = snapProcessed.clamp(0, p.totalToProcess!).clamp(0, maxPossible);

      p.processedCount = clampedProcessed;
      p.readyOut = clampedProcessed * p.outPerCycle!;
      p.state = (clampedProcessed >= p.totalToProcess!) ? 'ready' : 'running';
      p.updatedAt = now;

      final saved = await (Query<UserBuildingProgressModel>(ctx)
            ..where((x) => x.idProgress).equalTo(id)
            ..values = p)
          .updateOne();

      if (saved != null) updated.add(saved);
    }
    return Response.ok(updated);
  }

  Future<Response> _collect(Map<String, dynamic> b) async {
    final id = b['idProgress'] as int?;
    if (id == null) return AppResponse.badRequest(message: 'idProgress required');

    final p = await (Query<UserBuildingProgressModel>(ctx)
          ..where((x) => x.idProgress).equalTo(id))
        .fetchOne();
    if (p == null) return AppResponse.badRequest(message: 'not found');

    final amount = p.readyOut ?? 0;
    if (amount > 0) {
      // начислить игроку ресурсOut (user_resource upsert + amount)
      // ...
      p.readyOut = 0;
      p.state = (p.processedCount! >= p.totalToProcess!) ? 'collected' : 'running';
      await (Query<UserBuildingProgressModel>(ctx)
            ..where((x) => x.idProgress).equalTo(id)
            ..values.readyOut = 0
            ..values.state = p.state)
          .updateOne();
    }
    return Response.ok({'collected': amount});
  }

  @Operation.get('idUser')
  Future<Response> listByUser(@Bind.path('idUser') int idUser) async {
    final items = await (Query<UserBuildingProgressModel>(ctx)
          ..join(object: (x) => x.userBuilding!).where((ub) => ub.user!.userId).equalTo(idUser))
        .fetch();
    return Response.ok(items);
  }
}
