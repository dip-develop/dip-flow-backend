import 'package:injectable/injectable.dart';

import '../interfaces/interfaces.dart';
import '../repositories/repositories.dart';
import 'users_usecase.dart';

export 'users_usecase.dart';

@module
abstract class RegisterModule {
  @preResolve
  @Singleton(as: UsersUseCase)
  Future<UsersUseCaseImpl> usersUseCase(
          DataBaseRepository dataBaseRepository) =>
      UsersUseCaseImpl.getInstance(dataBaseRepository);
}
