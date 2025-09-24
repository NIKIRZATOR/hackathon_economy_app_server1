import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/building_type_output_model.dart';
import 'package:data/utils/app_response.dart';

class AppBuildingTypeOutputController extends ResourceController {
  AppBuildingTypeOutputController(this.managedContext);
  final ManagedContext managedContext;

  // GET /building-type-output
  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<BuildingTypeOutputModel>(managedContext)
            ..join(object: (x) => x.buildingType)
            ..join(object: (x) => x.resource))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения building_type_outputs');
    }
  }

  // GET /building-type-output/by-building/:idBuilding
  @Operation.get('idBuilding')
  Future<Response> getByBuilding(@Bind.path('idBuilding') int idBuilding) async {
    try {
      final list = await (Query<BuildingTypeOutputModel>(managedContext)
            ..where((x) => x.buildingType!.idBuildingType).equalTo(idBuilding)
            ..join(object: (x) => x.resource))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения выходов по зданию');
    }
  }

  // GET /building-type-output/by-resource/:idResource
  @Operation.get('idResource')
  Future<Response> getByResource(@Bind.path('idResource') int idResource) async {
    try {
      final list = await (Query<BuildingTypeOutputModel>(managedContext)
            ..where((x) => x.resource!.idResource).equalTo(idResource)
            ..join(object: (x) => x.buildingType))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения выходов по ресурсу');
    }
  }
}
