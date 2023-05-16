import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../objectbox.g.dart';
import '../../domain/models/auth_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/profile_model.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  late final Store _db;

  @override
  @PostConstruct()
  void init() {
    final directory = Platform.environment['DB_DIRECTORY'];
    _db = openStore(
      directory: directory,
    );
  }

  @override
  Future<ProfileModel?> getProfile(int id) =>
      Future.value(_db.box<ProfileEntity>().get(id)?.toModel());

  @override
  Future<ProfileModel> putProfile(ProfileModel user) =>
      Future.value(_db.box<ProfileEntity>().put(ProfileEntity.fromModel(user)))
          .then((value) => user.rebuild((p0) => p0..id = value));

  @override
  Future<void> deleteProfile(int id) =>
      Future.value(_db.box<ProfileEntity>().remove(id)).then((_) {});

  @override
  Future<SessionModel?> getSession(int id) =>
      Future.value(_db.box<SessionEntity>().get(id)?.toModel());

  @override
  Future<List<SessionModel>> getSessionsByProfileId(int id) {
    QueryBuilder<SessionEntity> query = _db.box<SessionEntity>().query()
      ..link(SessionEntity_.user, ProfileEntity_.id.equals(id));
    return Future.value(query.build().find())
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Future<List<SessionModel>> getExpiredSessions() => Future.value(_db
          .box<SessionEntity>()
          .query(SessionEntity_.dateExpired
              .lessThan(DateTime.now().toUtc().millisecondsSinceEpoch))
          .build()
          .find())
      .then((value) => value.map((e) => e.toModel()).toList());

  @override
  Future<SessionModel> putSession(SessionModel session) => Future.value(
          _db.box<SessionEntity>().put(SessionEntity.fromModel(session)))
      .then((value) => session.rebuild((p0) => p0..id = value));

  @override
  Future<void> deleteSession(int id) =>
      Future.value(_db.box<SessionEntity>().remove(id)).then((_) {});

  @override
  Future<void> deleteSessions(List<int> ids) =>
      Future.value(_db.box<SessionEntity>().removeMany(ids)).then((_) {});

  @override
  Future<EmailAuthModel?> getAuthByEmail(String email) => Future.value(_db
      .box<EmailAuthEntity>()
      .query(EmailAuthEntity_.email.equals(email))
      .build()
      .findFirst()
      ?.toModel());

  @override
  Future<void> deleteEmailAuth(int id) =>
      Future.value(_db.box<EmailAuthEntity>().remove(id)).then((_) {});

  @override
  Future<EmailAuthModel?> getEmailAuth(int id) =>
      Future.value(_db.box<EmailAuthEntity>().get(id)?.toModel());

  @override
  Future<EmailAuthModel> putEmailAuth(EmailAuthModel auth) => Future.value(
          _db.box<EmailAuthEntity>().put(EmailAuthEntity.fromModel(auth)))
      .then((value) => auth.rebuild((p0) => p0..id = value));

  @override
  @disposeMethod
  void dispose() {
    _db.close();
  }
}
