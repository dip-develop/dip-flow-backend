import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/exceptions/exceptions.dart';
import '../../domain/models/auth_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/profile_model.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  bool _isInneted = false;
  late final Isar _db;

  @override
  @PostConstruct()
  Future<void> init() {
    final directory = Platform.environment['DB_DIRECTORY'] ?? 'db';
    return Isar.openAsync(
      directory: directory,
      schemas: [
        EmailAuthEntitySchema,
        OpenAuthEntitySchema,
        ProfileEntitySchema,
        SessionEntitySchema,
      ],
    ).then((value) {
      _db = value;
      _isInneted = true;
    });
  }

  @override
  Future<ProfileModel?> getProfile(int id) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<ProfileEntity>().get(id)?.toModel()) */;

  @override
  Future<ProfileModel> putProfile(ProfileModel profile) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<ProfileEntity>().put(ProfileEntity.fromModel(profile)))
      .then((value) => profile.rebuild((p0) => p0..id = value)
      ) */
      ;

  @override
  Future<void> deleteProfile(int id) => // TODO: implement
      throw UnimplementedError() /* Future.value( _db.box<ProfileEntity>().remove(id)).then((_) {}) */;

  @override
  Future<SessionModel?> getSession(int id) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<SessionEntity>().get(id)?.toModel()) */;

  @override
  Future<List<SessionModel>> getSessionsBy(int profileId, String deviceId) {
    // TODO: implement
    throw UnimplementedError()
        /* QueryBuilder<SessionEntity> query = _db
        .box<SessionEntity>()
        .query(SessionEntity_.deviceId.equals(deviceId))
      ..link(SessionEntity_.user, ProfileEntity_.id.equals(profileId));
    return Future.value(query.build().find())
        .then((value) => value.map((e) => e.toModel()).toList()
        ) */
        ;
  }

  @override
  Future<List<SessionModel>> getExpiredSessions() => // TODO: implement
      throw UnimplementedError() /* Future.value(_db
          .box<SessionEntity>()
          .query(SessionEntity_.dateExpired
              .lessThan(DateTime.now().toUtc().millisecondsSinceEpoch))
          .build()
          .find())
      .then((value) => value.map((e) => e.toModel()).toList()) */
      ;

  @override
  Future<SessionModel> putSession(SessionModel session) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<SessionEntity>().put(SessionEntity.fromModel(session)))
      .then((value) => session.rebuild((p0) => p0..id = value)) */
      ;

  @override
  Future<void> deleteSession(int id) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<SessionEntity>().remove(id)).then((_) {}) */;

  @override
  Future<void> deleteSessions(List<int> ids) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<SessionEntity>().removeMany(ids)).then((_) {}) */;

  @override
  Future<EmailAuthModel?> getAuthByEmail(String email) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db
      .box<EmailAuthEntity>()
      .query(EmailAuthEntity_.email.equals(email))
      .build()
      .findFirst()
      ?.toModel()) */
      ;

  @override
  Future<void> deleteEmailAuth(int id) => // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<EmailAuthEntity>().remove(id)).then((_) {}) */;

  @override
  Future<EmailAuthModel?> getEmailAuth(int id) => // TODO: implement
      throw UnimplementedError() /*Future.value(_db.box<EmailAuthEntity>().get(id)?.toModel())*/;

  @override
  Future<EmailAuthModel> putEmailAuth(EmailAuthModel auth) =>
      // TODO: implement
      throw UnimplementedError() /* Future.value(_db.box<EmailAuthEntity>().put(EmailAuthEntity.fromModel(auth)))
      .then((value) => auth.rebuild((p0) => p0..id = value) 
      )*/
      ;

  @override
  @disposeMethod
  void dispose() {
    _getDb.close();
  }

  @override
  bool get isInneted => _isInneted;

  Isar get _getDb {
    if (!isInneted) throw DbException.notInneted();
    return _db;
  }
}
