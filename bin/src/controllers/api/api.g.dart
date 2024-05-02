// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ApiRouter(Api service) {
  final router = Router();
  router.mount(
    r'/auth',
    service._auth.call,
  );
  router.mount(
    r'/password',
    service._passwords.call,
  );
  return router;
}
