import 'package:bcrypt/bcrypt.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/resource_item_model.dart';
import 'package:data/models/user_resource_model.dart';
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

      // всё в транзакции: создаём юзера и стартовые ресурсы
      final created = await managedContext.transaction((tCtx) async {
        final user = await (Query<UserModel>(tCtx)
              ..values.username = body.username!.trim()
              ..values.cityTitle = body.cityTitle
              ..values.userLvl = 1
              ..values.userXp = 0
              ..values.lastClaimAt = null
              ..values.passwordHash = hash)
            .insert();

        // код ресурса -> стартовое количество
        const startPack = <String, double>{
          'coins': 300,
          'fuel': 10,
          'coffee beans': 10, // как в таблице (со пробелом)
          'fabric': 10,
          'product': 10,
        };

        // получаем все нужные ResourceItem одним запросом
        final needCodes = startPack.keys.toList();
        final items = await (Query<ResourceItemModel>(tCtx)
              ..where((r) => r.code).oneOf(needCodes))
            .fetch();

        // проверим наличие всех кодов
        final foundCodes = items.map((e) => e.code).toSet();
        final missing = needCodes.where((c) => !foundCodes.contains(c)).toList();
        if (missing.isNotEmpty) {
          throw StateError('В справочнике ресурсов отсутствуют коды: $missing');
        }

        // вставляем user_resources
        for (final item in items) {
          final amount = startPack[item.code]!;
          await (Query<UserResourceModel>(tCtx)
                ..values.user = (UserModel()..userId = user.userId)
                ..values.resource = (ResourceItemModel()..idResource = item.idResource)
                ..values.amount = amount)
              .insert();
        }

        return user;
      });

      return Response.ok({
        'userId': created!.userId,
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
