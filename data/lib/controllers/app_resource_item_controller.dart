import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/resource_item_model.dart';
import 'package:data/utils/app_response.dart';

class AppResourceItemController extends ResourceController {
  AppResourceItemController(this.managedContext);
  final ManagedContext managedContext;

  // GET /resource-item
  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<ResourceItemModel>(managedContext)
            ..sortBy((r) => r.idResourceItem, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения ресурсов');
    }
  }

  // GET /resource-item/:idItem
  @Operation.get('idItem')
  Future<Response> getById(@Bind.path('idItem') int id) async {
    try {
      final item = await (Query<ResourceItemModel>(managedContext)
            ..where((r) => r.idResourceItem).equalTo(id))
          .fetchOne();
      return item == null ? Response.notFound() : Response.ok(item);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения ресурса');
    }
  }
}
