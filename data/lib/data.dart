import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:data/controllers/app_building_type_controller.dart';
import 'package:data/controllers/app_resource_item_controller.dart';
import 'package:data/controllers/app_user_controller.dart';
import 'package:data/utils/app_env.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    
    ..route('user/register').link(() => AppUserController(managedContext))
    ..route('user/login').link(() => AppUserController(managedContext))
    ..route('user/[:idUser]').link(() => AppUserController(managedContext))
    ..route('building-type/[:idBuilding]').link(() => AppBuildingTypeController(managedContext))
    ..route('resource-item/[:idItem]').link(() => AppResourceItemController(managedContext));

  PostgreSQLPersistentStore _initDatabase() {
    return PostgreSQLPersistentStore(
      AppEnv.dbUsername,
      AppEnv.dbPassword,
      AppEnv.dbHost,
      int.tryParse(AppEnv.dbPort),
      AppEnv.dbDatabaseName,
    );
  }
}
