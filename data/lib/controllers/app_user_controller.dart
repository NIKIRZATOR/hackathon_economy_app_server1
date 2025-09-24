import 'package:bcrypt/bcrypt.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';
import 'package:data/utils/app_response.dart';

class AppUserController extends ResourceController {
  AppUserController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.post('register')
  Future<Response> register(@Bind.body() UserModel body) async {
    if (
      (body.username ?? '').trim().isEmpty ||
      (body.password ?? '').isEmpty ||
      (body.cityTitle ?? '').trim().isEmpty
      ) {
      return AppResponse.badRequest(message: 'username, password и cityTitle обязательны');
    }

    try {
      final exists = await (Query<UserModel>(managedContext)
            ..where((u) => u.username).equalTo(body.username!.trim()))
          .fetchOne();
      if (exists != null) {
        return AppResponse.badRequest(message: 'Пользователь уже существует');
      }

      final hash = BCrypt.hashpw(body.password!, BCrypt.gensalt());

      final q = Query<UserModel>(managedContext)
        ..values.username = body.username!.trim()
        ..values.cityTitle = body.cityTitle
        ..values.userLvl = 1
        ..values.userXp = 0
        ..values.lastClaimAt = null
        ..values.passwordHash = hash;

      final created = await q.insert();
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

  @Operation.post('login')
  Future<Response> login(@Bind.body() UserModel body) async {
    if ((body.username ?? '').trim().isEmpty || (body.password ?? '').isEmpty) {
      return AppResponse.badRequest(message: 'username и password обязательны');
    }

    try {
      final user = await (Query<UserModel>(managedContext)
            ..where((u) => u.username).equalTo(body.username!.trim())
            ..returningProperties((u) => [u.userId, u.username, u.cityTitle, u.userLvl, u.userXp, u.lastClaimAt, u.passwordHash]))
          .fetchOne();

      if (user == null || user.passwordHash == null) {
        return AppResponse.badRequest(message: 'Неверный логин или пароль');
      }

      final ok = BCrypt.checkpw(body.password!, user.passwordHash!);
      if (!ok) {
        return AppResponse.badRequest(message: 'Неверный логин или пароль');
      }

      return Response.ok({
        'userId': user.userId,
        'username': user.username,
        'cityTitle': user.cityTitle,
        'userLvl': user.userLvl,
        'userXp': user.userXp,
        'lastClaimAt': user.lastClaimAt?.toIso8601String(),
      });
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка входа');
    }
  }

  @Operation.get()
  Future<Response> getAll() async {
    try {
      final list = await (Query<UserModel>(managedContext)
            ..sortBy((u) => u.userId, QuerySortOrder.ascending))
          .fetch();
      return list.isEmpty ? Response.notFound() : Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения пользователей');
    }
  }

  @Operation.get('idUser')
  Future<Response> getById(@Bind.path('idUser') int id) async {
    try {
      final item = await (Query<UserModel>(managedContext)
            ..where((u) => u.userId).equalTo(id))
          .fetchOne();
      return item == null ? AppResponse.badRequest(message: 'Не найден') : Response.ok(item);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения пользователя');
    }
  }

  @Operation.put('idUser')
  Future<Response> update(
    @Bind.path('idUser') int id,
    @Bind.body() UserModel body,
  ) async {
    try {
      final exists = await managedContext.fetchObjectWithID<UserModel>(id);
      if (exists == null) return AppResponse.badRequest(message: 'Не найден');

      final q = Query<UserModel>(managedContext)
        ..where((u) => u.userId).equalTo(id)
        ..values.userLvl = body.userLvl ?? exists.userLvl
        ..values.userXp = body.userXp ?? exists.userXp
        ..values.lastClaimAt = body.lastClaimAt ?? exists.lastClaimAt;


      final updated = await q.updateOne();
      if (updated == null) {
        return AppResponse.serverError(null, message: 'Обновление не выполнено');
      }
      return AppResponse.ok(message: 'Профиль обновлён');
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновления');
    }
  }
}
