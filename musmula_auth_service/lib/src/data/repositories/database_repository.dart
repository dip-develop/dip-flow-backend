import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/models/auth_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  late final Isar _db;
  @override
  Future<void> init() {
    final name = Platform.environment['DB_NAME'];
    final directory = Platform.environment['DB_DIRECTORY'];
    return Isar.open([
      UserEntitySchema,
      EmailAuthEntitySchema,
      OpenAuthEntitySchema,
      SessionEntitySchema
    ], name: name ?? 'default', directory: directory)
        .then((value) => _db = value);
  }

  @override
  Future<UserModel?> getUser(int userId) =>
      _db.userEntitys.get(userId).then((value) => value?.toModel());

  @override
  Future<UserModel> putUser(UserModel user) =>
      _db.writeTxn(() => _db.userEntitys
          .put(UserEntity.fromModel(user))
          .then((value) => user.rebuild((p0) => p0..id = value)));

  @override
  Future<void> deleteUser(int userId) =>
      _db.writeTxn(() => _db.sessionEntitys.delete(userId));

  @override
  Future<SessionModel?> getSession(int sessionId) =>
      _db.sessionEntitys.get(sessionId).then((value) => value?.toModel());

  @override
  Future<List<SessionModel>> getSessionsByUserId(int userId) =>
      _db.sessionEntitys
          .filter()
          .userIdEqualTo(userId)
          .findAll()
          .then((value) => value.map((e) => e.toModel()).toList());

  @override
  Future<List<SessionModel>> getExpiredSessions() => _db.sessionEntitys
      .filter()
      .dateExpiredLessThan(DateTime.now().toUtc())
      .findAll()
      .then((value) => value.map((e) => e.toModel()).toList());

  @override
  Future<SessionModel> putSession(SessionModel session) =>
      _db.writeTxn(() => _db.sessionEntitys
          .put(SessionEntity.fromModel(session))
          .then((value) => session.rebuild((p0) => p0..id = value)));

  @override
  Future<void> deleteSession(int id) =>
      _db.writeTxn(() => _db.userEntitys.delete(id));

  @override
  Future<void> deleteSessions(List<int> ids) =>
      _db.writeTxn(() => _db.sessionEntitys.deleteAll(ids));

  @override
  Future<EmailAuthModel?> getAuthByEmail(String email) => _db.emailAuthEntitys
      .filter()
      .emailEqualTo(email)
      .findFirst()
      .then((value) => value?.toModel());

  @override
  Future<void> deleteEmailAuth(int authId) =>
      _db.writeTxn(() => _db.emailAuthEntitys.delete(authId));

  @override
  Future<EmailAuthModel?> getEmailAuth(int authId) =>
      _db.emailAuthEntitys.get(authId).then((value) => value?.toModel());

  @override
  Future<EmailAuthModel> putEmailAuth(EmailAuthModel auth) =>
      _db.writeTxn(() => _db.emailAuthEntitys
          .put(EmailAuthEntity.fromModel(auth))
          .then((value) => auth.rebuild((p0) => p0..id = value)));
}
