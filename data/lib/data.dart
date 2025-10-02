import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:data/controllers/app_building_type_controller.dart';
import 'package:data/controllers/app_building_type_input_controller.dart';
import 'package:data/controllers/app_building_type_output_controller.dart';
import 'package:data/controllers/app_resource_item_controller.dart';
import 'package:data/controllers/app_user_building_controller.dart';
import 'package:data/controllers/app_user_building_progress_controller.dart';
import 'package:data/controllers/app_user_tasks_done_controller.dart';
import 'package:data/controllers/user_controllers/app_user_controller.dart';
import 'package:data/controllers/app_user_resource_controller.dart';
import 'package:data/controllers/user_controllers/app_user_login_controller.dart';
import 'package:data/controllers/user_controllers/app_user_register_controller.dart';
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
    
    ..route('user/register').link(() => AppUserRegisterController(managedContext))
    ..route('user/login').link(() => AppUserLoginController(managedContext))
    ..route('user/[:idUser]').link(() => AppUserController(managedContext))

    ..route('building-type/[:idBuilding]').link(() => AppBuildingTypeController(managedContext))

    ..route('resource-item/[:idItem]').link(() => AppResourceItemController(managedContext))

    ..route('user-resource').link(() => AppUserResourceController(managedContext))
    ..route('user-resource/by-user/:idUser').link(() => AppUserResourceController(managedContext))
    ..route('user-resource/:idUserResource').link(() => AppUserResourceController(managedContext))

    ..route('user-building').link(() => AppUserBuildingController(managedContext))
    ..route('user-building/by-user/:idUser').link(() => AppUserBuildingController(managedContext))
    ..route('user-building/:idUserBuilding').link(() => AppUserBuildingController(managedContext))
    
    ..route('building-type-input').link(() => AppBuildingTypeInputController(managedContext))
    ..route('building-type-input/by-building/:idBuilding').link(() => AppBuildingTypeInputController(managedContext))
    ..route('building-type-input/by-resource/:idResource').link(() => AppBuildingTypeInputController(managedContext))

    ..route('building-type-output').link(() => AppBuildingTypeOutputController(managedContext))
    ..route('building-type-output/by-building/:idBuilding').link(() => AppBuildingTypeOutputController(managedContext))
    ..route('building-type-output/by-resource/:idResource').link(() => AppBuildingTypeOutputController(managedContext))
    
   ..route('user-building-progress').link(() => AppUserBuildingProgressController(managedContext))
    ..route('user-building-progress/by-user/:idUser').link(() => AppUserBuildingProgressController(managedContext))
    ..route('user-building-progress/:idProgress').link(() => AppUserBuildingProgressController(managedContext))

    ..route('user-tasks-done/:idUser').link(() => AppUserTasksDoneController(managedContext))
;

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
