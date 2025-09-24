import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_model.dart';
import 'package:data/utils/app_response.dart';

class AppBuildingTypeController extends ResourceController {
  AppBuildingTypeController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<BuildingTypeModel>(managedContext)
            ..sortBy((b) => b.idBuildingType, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения типов зданий');
    }
  }

  @Operation.get('idBuilding')
  Future<Response> getById(@Bind.path('idBuilding') int id) async {
    try {
      final item = await (Query<BuildingTypeModel>(managedContext)
            ..where((b) => b.idBuildingType).equalTo(id))
          .fetchOne();
      return item == null ? Response.notFound() : Response.ok(item);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения типа здания');
    }
  }
}
