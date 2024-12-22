import 'dart:async';
import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

import '../../domain/exceptions/exceptions.dart';
import '../../domain/models/auth_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/profile_model.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  bool _isInneted = false;
  Timer? _timer;
  final _boxOpenedTime = Map<String, DateTime>.identity();
  final _lock = Lock(reentrant: true);

  @override
  @PostConstruct()
  void init() {
    final directory = Platform.environment['DB_DIRECTORY'] ?? 'db';
    final dbUnUsedClosePeriod =
        int.tryParse(Platform.environment['DB_UNUSED_CLOSE_PERIOD'] ?? '') ??
            10;
    if (!_isInneted) {
      Hive.init(directory);
    }

    final openAuthEntityAdapter = OpenAuthEntityAdapter();
    final emailAuthEntityAdapter = EmailAuthEntityAdapter();
    final profileEntityAdapter = ProfileEntityAdapter();
    final sessionEntityAdapter = SessionEntityAdapter();

    if (!Hive.isAdapterRegistered(openAuthEntityAdapter.typeId)) {
      Hive.registerAdapter(openAuthEntityAdapter);
    }
    if (!Hive.isAdapterRegistered(emailAuthEntityAdapter.typeId)) {
      Hive.registerAdapter(emailAuthEntityAdapter);
    }
    if (!Hive.isAdapterRegistered(profileEntityAdapter.typeId)) {
      Hive.registerAdapter(profileEntityAdapter);
    }
    if (!Hive.isAdapterRegistered(sessionEntityAdapter.typeId)) {
      Hive.registerAdapter(sessionEntityAdapter);
    }

    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    Timer.periodic(
        Duration(seconds: dbUnUsedClosePeriod), (_) => _closeUnusedBoxs());
    _isInneted = true;
  }

  @override
  Future<ProfileModel?> getProfile(String id) => _getBox<ProfileEntity>()
      .then((box) => box.get(id))
      .then((value) => value?.toModel());

  @override
  Future<ProfileModel> putProfile(ProfileModel profile) {
    final id = profile.id ?? '';
    return _getBox<ProfileEntity>()
        .then((box) => box.put(id, ProfileEntity.fromModel(profile)))
        .then((_) => profile.rebuild((p0) => p0..id = id));
  }

  @override
  Future<void> deleteProfile(String id) =>
      _getBox<ProfileEntity>().then((box) => box.delete(id));

  @override
  Future<SessionModel?> getSession(String id) => _getBox<SessionEntity>()
      .then((box) => box.get(id))
      .then((value) => value?.toModel());

  @override
  Future<List<SessionModel>> getSessionsBy(String profileId, String deviceId) =>
      _getBox<SessionEntity>()
          .then((box) => box.values.where((element) =>
              element.userId == profileId && element.deviceId == deviceId))
          .then((value) => value.map((e) => e.toModel()).toList());

  @override
  Future<List<SessionModel>> getExpiredSessions() => _getBox<SessionEntity>()
      .then((box) => box.values.where(
          (element) => element.dateExpired.isAfter(DateTime.now().toUtc())))
      .then((value) => value.map((e) => e.toModel()).toList());

  @override
  Future<SessionModel> putSession(SessionModel session) {
    final id = session.id ?? '';
    return _getBox<SessionEntity>()
        .then((box) => box.put(id, SessionEntity.fromModel(session)))
        .then((_) => session.rebuild((p0) => p0..id = id));
  }

  @override
  Future<void> deleteSession(String id) =>
      _getBox<SessionEntity>().then((box) => box.delete(id));

  @override
  Future<void> deleteSessions(List<String> ids) =>
      _getBox<SessionEntity>().then((box) => box.deleteAll(ids));

  @override
  Future<EmailAuthModel?> getAuthByEmail(
          String email) =>
      _getBox<EmailAuthEntity>()
          .then((box) =>
              box.values.firstWhereOrNull((element) => element.email == email))
          .then((value) => value?.toModel());

  @override
  Future<void> deleteEmailAuth(String id) =>
      _getBox<EmailAuthEntity>().then((box) => box.delete(id));

  @override
  Future<EmailAuthModel?> getEmailAuth(String id) => _getBox<EmailAuthEntity>()
      .then((box) => box.get(id))
      .then((value) => value?.toModel());

  @override
  Future<EmailAuthModel> putEmailAuth(EmailAuthModel auth) {
    final id = auth.id ?? '';
    return _getBox<EmailAuthEntity>()
        .then((box) => box.put(id, EmailAuthEntity.fromModel(auth)))
        .then((_) => auth.rebuild((p0) => p0..id = id));
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    _timer?.cancel();
    await Hive.close().then((_) {
      _isInneted = false;
    });
  }

  @override
  bool get isInneted => _isInneted;

  void _closeUnusedBoxs() {
    final boxes = _boxOpenedTime.entries
        .where((element) => element.value.isAfter(DateTime.now().toUtc()));

    for (var boxName in boxes.map((e) => e.key)) {
      _lock.synchronized(() {
        if (Hive.isBoxOpen(boxName)) {
          final box = switch (boxName) {
            'open_auth_box' => Hive.box<OpenAuthEntity>(boxName),
            'email_auth_box' => Hive.box<EmailAuthEntity>(boxName),
            'profile_box' => Hive.box<ProfileEntity>(boxName),
            'session_box' => Hive.box<SessionEntity>(boxName),
            _ => throw DbException.internalError()
          };
          return box.close().then((_) =>
              _boxOpenedTime.removeWhere((key, value) => key == boxName));
        }
        _boxOpenedTime.removeWhere((key, value) => key == boxName);
      });
    }
  }

  Future<Box<T>> _getBox<T>() {
    if (!isInneted) throw DbException.notInneted();
    return _lock.synchronized<Box<T>>(() {
      final boxName = switch (T) {
        OpenAuthEntity _ => 'open_auth_box',
        EmailAuthEntity _ => 'email_auth_box',
        ProfileEntity _ => 'profile_box',
        SessionEntity _ => 'session_box',
        _ => throw DbException.internalError()
      };

      _boxOpenedTime[boxName] = DateTime.now().toUtc();
      if (Hive.isBoxOpen(boxName)) {
        return Future.value(Hive.box<T>(boxName));
      } else {
        return Hive.openBox<T>(boxName);
      }
    });
  }
}
