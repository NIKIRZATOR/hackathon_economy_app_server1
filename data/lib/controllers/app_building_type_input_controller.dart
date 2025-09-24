import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_input_model.dart';
import 'package:data/utils/app_response.dart';

class AppBuildingTypeInputController extends ResourceController {
  AppBuildingTypeInputController(this.managedContext);
  final ManagedContext managedContext;

  // GET /building-type-input
  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<BuildingTypeInputModel>(managedContext)
            ..join(object: (x) => x.buildingType)
            ..join(object: (x) => x.resource))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения building_type_inputs');
    }
  }

  // GET /building-type-input/by-building/:idBuilding
  @Operation.get('idBuilding')
  Future<Response> getByBuilding(@Bind.path('idBuilding') int idBuilding) async {
    try {
      final list = await (Query<BuildingTypeInputModel>(managedContext)
            ..where((x) => x.buildingType!.idBuildingType).equalTo(idBuilding)
            ..join(object: (x) => x.resource))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения входов по зданию');
    }
  }

  // GET /building-type-input/by-resource/:idResource
  @Operation.get('idResource')
  Future<Response> getByResource(@Bind.path('idResource') int idResource) async {
    try {
      final list = await (Query<BuildingTypeInputModel>(managedContext)
            ..where((x) => x.resource!.idResource).equalTo(idResource)
            ..join(object: (x) => x.buildingType))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения входов по ресурсу');
    }
  }
}
