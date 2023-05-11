abstract class EmailRepository {
  Future<void> sendMail(
      {required List<String> recipients,
      required String subject,
      required String html});
}
