import 'package:injectable/injectable.dart';

import '../interfaces/interfaces.dart';
import '../repositories/repositories.dart';
import 'time_trackings_usecase.dart';

export 'time_trackings_usecase.dart';

@module
abstract class RegisterModule {
  @preResolve
  @Singleton(as: TimeTrackingsUseCase)
  Future<TimeTrackingsUseCaseImpl> usersUseCase(
          DataBaseRepository dataBaseRepository) =>
      TimeTrackingsUseCaseImpl.getInstance(dataBaseRepository);
}
