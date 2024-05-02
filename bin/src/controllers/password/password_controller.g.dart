// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$PasswordControllerRouter(PasswordController service) {
  final router = Router();
  router.add(
    'POST',
    r'/add',
    service.add,
  );
  router.add(
    'POST',
    r'/get',
    service.get,
  );
  router.add(
    'POST',
    r'/send',
    service.send,
  );
  router.add(
    'POST',
    r'/join',
    service.join,
  );
  return router;
}
