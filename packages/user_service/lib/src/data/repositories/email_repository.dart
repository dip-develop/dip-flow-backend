import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../domain/repositories/repositories.dart';

@Singleton(as: EmailRepository)
class EmailRepositoryImpl implements EmailRepository {
  late final SmtpServer _smtp;

  EmailRepositoryImpl() {
    final email = Platform.environment['ADDRESS_EMAIL'] ?? '';
    final password = Platform.environment['PASSWORD_EMAIL'] ?? '';
    final smtp = Platform.environment['SMTP_ADDRESS_EMAIL'] ?? '';
    final port =
        int.tryParse(Platform.environment['SMTP_PORT_EMAIL'] ?? '') ?? 587;
    _smtp = SmtpServer(smtp,
        port: port, username: email, password: password, ssl: true);
  }

  @override
  Future<void> sendMail(
      {required List<String> recipients,
      required String subject,
      required String html}) {
    final email = Platform.environment['ADDRESS_EMAIL'] ?? '';
    final message = Message()
      ..from = Address(email, 'DIP Flow')
      ..recipients.addAll(recipients)
      ..subject = subject
      ..html = html;

    if ((_smtp.username?.isNotEmpty ?? false) &&
        (_smtp.password?.isNotEmpty ?? false)) {
      return send(message, _smtp);
    }
    return Future.value();
  }
}
