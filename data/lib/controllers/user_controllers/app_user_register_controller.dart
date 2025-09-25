import 'package:bcrypt/bcrypt.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserRegisterController extends ResourceController {
  AppUserRegisterController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> register(@Bind.body() UserModel body) async {
    if ((body.username ?? '').trim().isEmpty ||
        (body.password ?? '').isEmpty ||
        (body.cityTitle ?? '').trim().isEmpty) {
      return AppResponse.badRequest(
        message: 'username, password и cityTitle обязательны',
      );
    }

    try {
      final exists = await (Query<UserModel>(managedContext)
            ..where((u) => u.username).equalTo(body.username!.trim()))
          .fetchOne();
      if (exists != null) {
        return AppResponse.badRequest(message: 'Пользователь уже существует');
      }

      final hash = BCrypt.hashpw(body.password!, BCrypt.gensalt());
      final created = await (Query<UserModel>(managedContext)
            ..values.username = body.username!.trim()
            ..values.cityTitle = body.cityTitle
            ..values.userLvl = 1
            ..values.userXp = 0
            ..values.lastClaimAt = null
            ..values.passwordHash = hash)
          .insert();

      return Response.ok({
        'userId': created.userId,
        'username': created.username,
        'cityTitle': created.cityTitle,
        'userLvl': created.userLvl,
        'userXp': created.userXp,
        'lastClaimAt': created.lastClaimAt?.toIso8601String(),
      });
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка регистрации');
    }
  }
}
