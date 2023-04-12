import 'package:theteam_auth_service/src/data/repositories/database_repository.dart';
import 'package:theteam_auth_service/src/domain/interfaces/interfaces.dart';
import 'package:theteam_auth_service/src/domain/models/session_model.dart';
import 'package:theteam_auth_service/src/domain/repositories/repositories.dart';
import 'package:theteam_auth_service/src/domain/usecases/usecases.dart';
import 'package:test/test.dart';

void main() {
  group('Users UseCase', () {
    test('Generate and check token', () async {
      final DataBaseRepository dataBaseRepository = DataBaseRepositoryImpl();
      final UsersUseCase usersUseCase =
          await UsersUseCaseImpl.getInstance(dataBaseRepository);

      final dateCreated =
          DateTime.now().toUtc().add(Duration(days: -1, seconds: 1));
      final dateExpired = dateCreated.add(Duration(days: 1));

      final session = SessionModel((p0) => p0
        ..id = 1
        ..userId = 2
        ..dateCreated = dateCreated
        ..dateExpired = dateExpired);

      final token = usersUseCase.generateRefreshToken(session);
      expect(usersUseCase.checkRefreshToken(token), true);
    });
  });
}
