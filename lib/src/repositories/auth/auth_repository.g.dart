// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthRepositoryRouter(AuthRepository service) {
  final router = Router();
  router.add(
    'POST',
    r'/login',
    service.auth,
  );
  router.add(
    'POST',
    r'/register',
    service.register,
  );
  return router;
}
