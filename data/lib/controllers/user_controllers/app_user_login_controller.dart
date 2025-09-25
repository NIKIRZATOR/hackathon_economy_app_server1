import 'package:bcrypt/bcrypt.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserLoginController extends ResourceController {
  AppUserLoginController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.post()
  Future<Response> login(@Bind.body() UserModel body) async {
    if ((body.username ?? '').trim().isEmpty || (body.password ?? '').isEmpty) {
      return AppResponse.badRequest(message: 'username и password обязательны');
    }

    try {
      // 1) Ищем пользователя + берем hash
      final user = await (Query<UserModel>(managedContext)
            ..where((u) => u.username).equalTo(body.username!.trim())
            ..returningProperties((u) => [
              u.userId, u.username, u.cityTitle, u.userLvl, u.userXp, u.lastClaimAt, u.passwordHash
            ]))
          .fetchOne();

      if (user == null || user.passwordHash == null) {
        return AppResponse.badRequest(message: 'Неверный логин или пароль');
      }
      if (!BCrypt.checkpw(body.password!, user.passwordHash!)) {
        return AppResponse.badRequest(message: 'Неверный логин или пароль');
      }

      // 2) Обновляем lastClaimAt на сервере (только сейчас)
      final now = DateTime.now().toUtc(); // хранение в UTC удобно для кросс-таймзон
      await (Query<UserModel>(managedContext)
            ..where((u) => u.userId).equalTo(user.userId)
            ..values.lastClaimAt = now)
          .updateOne();

      // 3) Отдаём профиль уже с обновлённым lastClaimAt
      return Response.ok({
        'userId': user.userId,
        'username': user.username,
        'cityTitle': user.cityTitle,
        'userLvl': user.userLvl,
        'userXp': user.userXp,
        'lastClaimAt': now.toIso8601String(),
      });
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка входа');
    }
  }
}
