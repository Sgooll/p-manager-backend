// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_repository.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$MainRepositoryRouter(MainRepository service) {
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
