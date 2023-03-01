import 'package:isar/isar.dart';

part 'session_entity.g.dart';

@collection
class SessionEntity {
  final Id id = Isar.autoIncrement;
  final int userId;
  final String session;
  final DateTime dateCreated;

  SessionEntity(
      {required this.userId, required this.session, required this.dateCreated});
}
