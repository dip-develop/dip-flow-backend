import 'package:injectable/injectable.dart';

//import '../../../objectbox.g.dart';
import '../../domain/repositories/repositories.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  //late final Store _db;
  @override
  Future<void> init() {
    /* final directory = Platform.environment['DB_DIRECTORY'];
    _db = openStore(
      directory: directory,
    ); */
    return Future.value();
  }
}
