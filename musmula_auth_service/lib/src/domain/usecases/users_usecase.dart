import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../exceptions/exceptions.dart';
import '../interfaces/interfaces.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

const _secretRefreshJWT = 'df6KJbwe7hj345kjbjkK4354KL12';
const _secretAccessJWT = 'hD4nsd84n';
const _secretPassword = '3Jn5kaserjJnbf';
const _issuer = 'musmula_auth_service';

class UsersUseCaseImpl implements UsersUseCase {
  final DataBaseRepository _dataBaseRepository;

  UsersUseCaseImpl._(this._dataBaseRepository);

  static Future<UsersUseCaseImpl> getInstance(
      DataBaseRepository dataBaseRepository) {
    return dataBaseRepository
        .init()
        .then((_) => UsersUseCaseImpl._(dataBaseRepository));
  }

  @override
  Future<SessionModel> refreshToken(String token) {
    final jwt = _parseToken(token, _secretRefreshJWT);
    final sessionID = int.tryParse(jwt?.jwtId ?? '');
    if (sessionID == null) {
      throw AuthException.wrongAuthData();
    }
    return _dataBaseRepository
        .getSession(sessionID)
        .then((session) => _dataBaseRepository.putSession(SessionModel(
              (p0) => p0
                ..id = session?.id
                ..userId = session?.userId
                ..dateCreated = DateTime.now().toUtc()
                ..dateExpired = DateTime.now().add(Duration(days: 7)).toUtc(),
            )));
  }

  @override
  Future<SessionModel> signInByEmail(
      {required String email, required String password}) {
    return _dataBaseRepository.getAuthByEmail(email).then((auth) {
      if (auth == null) return Future.error(AuthException.wrongEmailData());
      if (_getPasswordHash(password) != auth.password) {
        return Future.error(AuthException.wrongEmailData());
      }
      return _dataBaseRepository
          .getSessionsByUserId(auth.userId)
          .then((value) => _dataBaseRepository.putSession(SessionModel(
                (p0) => p0
                  ..id = value.isNotEmpty ? value.first.id : null
                  ..userId = auth.userId
                  ..dateCreated = DateTime.now().toUtc()
                  ..dateExpired = DateTime.now().add(Duration(days: 7)).toUtc(),
              )));
    });
  }

  @override
  Future<SessionModel> signUpByEmail(
      {required String name, required String email, required String password}) {
    return _dataBaseRepository.getAuthByEmail(email).then((auth) {
      if (auth != null) return Future.error(AuthException.doubleAuthData());
      return _dataBaseRepository
          .putUser(UserModel(
            (p0) => p0
              ..name = name
              ..dateCreated = DateTime.now().toUtc(),
          ))
          .then((user) => _dataBaseRepository.putEmailAuth(EmailAuthModel(
                (p0) => p0
                  ..userId = user.id
                  ..email = email
                  ..password = _getPasswordHash(password)
                  ..dateCreated = DateTime.now().toUtc(),
              )))
          .then((auth) => _dataBaseRepository.putSession(SessionModel(
                (p0) => p0
                  ..userId = auth.userId
                  ..dateCreated = DateTime.now().toUtc()
                  ..dateExpired = DateTime.now().add(Duration(days: 7)).toUtc(),
              )));
    });
  }

  @override
  bool checkRefreshToken(String token) {
    return _parseToken(token, _secretRefreshJWT) != null;
  }

  @override
  bool checkAccessToken(String token) {
    return _parseToken(token, _secretAccessJWT) != null;
  }

  @override
  String generateRefreshToken(SessionModel session) {
    return _generateToken(
        dateCreated: session.dateCreated,
        dateExpired: session.dateExpired,
        jwtId: session.userId.toString(),
        secret: _secretRefreshJWT);
  }

  @override
  String generateAccessToken(SessionModel session,
      {Duration duration = const Duration(hours: 1)}) {
    final dateNow = DateTime.now().toUtc();
    final dateEnd = dateNow.add(duration);
    return _generateToken(
        dateCreated: dateNow,
        dateExpired: session.dateExpired.isAfter(dateEnd)
            ? dateEnd
            : session.dateExpired,
        jwtId: session.id.toString(),
        secret: _secretAccessJWT);
  }

  @override
  Future<void> deleteExpiredSessions() => _dataBaseRepository
      .getExpiredSessions()
      .then((sessions) => _dataBaseRepository
          .deleteSessions(sessions.map((e) => e.id!).toList()));

  String _generateToken(
      {required DateTime dateCreated,
      required DateTime dateExpired,
      required String jwtId,
      required String secret}) {
    final jwt = JWT(
      {
        'iat': dateCreated.millisecondsSinceEpoch ~/ 1000,
        'exp': dateExpired.millisecondsSinceEpoch ~/ 1000,
        'nbf': dateCreated.millisecondsSinceEpoch ~/ 1000,
      },
      issuer: _issuer,
      jwtId: jwtId,
    );

    return jwt.sign(SecretKey(secret), noIssueAt: false);
  }

  @override
  Future<UserModel> getUser(String token) {
    final jwt = _parseToken(token, _secretAccessJWT);
    final sessionID = int.tryParse(jwt?.jwtId ?? '');
    if (sessionID == null) {
      throw AuthException.wrongAuthData();
    }
    return _dataBaseRepository.getSession(sessionID).then((session) {
      if (session == null) {
        throw AuthException.wrongAuthData();
      }
      return _dataBaseRepository.getUser(session.userId).then((user) {
        if (user == null) {
          throw AuthException.wrongAuthData();
        }
        return user;
      });
    });
  }

  String _getPasswordHash(String password) {
    final passwordBytes = utf8.encode(password);
    final secretBytes = utf8.encode(_secretPassword);
    final digest = sha256.convert([...passwordBytes, ...secretBytes]);
    return digest.toString();
  }

  JWT? _parseToken(String token, String secret) {
    final jwt = JWT.tryVerify(token, SecretKey(secret));
    if (jwt == null) return null;
    final payload = jwt.payload;
    if (payload is! Map) return null;
    if (!payload.containsKey('exp')) return null;
    final dateExpired = DateTime.fromMillisecondsSinceEpoch(
        payload['exp'] * 1000,
        isUtc: false);

    return jwt.issuer == _issuer &&
            dateExpired.difference(DateTime.now().toUtc()) > Duration.zero
        ? jwt
        : null;
  }
}
