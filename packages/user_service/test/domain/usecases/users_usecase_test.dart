import 'package:user_service/src/data/repositories/database_repository.dart';
import 'package:user_service/src/data/repositories/email_repository.dart';
import 'package:user_service/src/domain/interfaces/interfaces.dart';
import 'package:user_service/src/domain/models/session_model.dart';
import 'package:user_service/src/domain/repositories/repositories.dart';
import 'package:user_service/src/domain/usecases/usecases.dart';
import 'package:test/test.dart';

void main() {
  group('Users UseCase', () {
    test('Generate and check token', () async {
      final DataBaseRepository dataBaseRepository = DataBaseRepositoryImpl()
        ..init();
      final EmailRepository emailRepository = EmailRepositoryImpl();
      final AuthUseCase usersUseCase =
          AuthUseCaseImpl(dataBaseRepository, emailRepository);

      final dateCreated =
          DateTime.now().toUtc().add(Duration(days: -1, seconds: 1));
      final dateExpired = dateCreated.add(Duration(days: 1));

      final session = SessionModel((p0) => p0
        ..id = '1'
        ..userId = '2'
        ..deviceId = '3'
        ..dateCreated = dateCreated
        ..dateExpired = dateExpired);

      final token = usersUseCase.generateRefreshToken(session);
      expect(usersUseCase.checkRefreshToken(token), true);
    });
  });
}
