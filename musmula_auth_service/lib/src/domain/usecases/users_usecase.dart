import 'package:injectable/injectable.dart';

import '../interfaces/interfaces.dart';
import '../repositories/repositories.dart';

@Singleton(as: UsersUseCase)
class UsersUseCaseImpl implements UsersUseCase {
  final DataBaseRepository _dataBaseRepository;

  UsersUseCaseImpl(this._dataBaseRepository) {
    _dataBaseRepository.init();
  }
}
