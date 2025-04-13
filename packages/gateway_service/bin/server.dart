import 'package:gateway_service/gateway_service.dart';
import 'package:logging/logging.dart';

void main(List<String> args) {
  Logger.root.level =
      args.contains('-v') || args.contains('verbose') ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  startServer();
}
