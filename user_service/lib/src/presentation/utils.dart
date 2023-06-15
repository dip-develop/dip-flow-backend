import 'package:grpc/grpc.dart';

class Utils {
  static String? getToken(ServiceCall call) => (call.clientMetadata
              ?.map((key, value) => MapEntry(key.toLowerCase(), value))
              .containsKey('authorization') ??
          false)
      ? call.clientMetadata
          ?.map((key, value) => MapEntry(key.toLowerCase(), value))[
              'authorization']
          ?.replaceAll('Bearer', '')
          .replaceAll('bearer', '')
          .trim()
      : null;

  static String? getDeviceId(ServiceCall call) => (call.clientMetadata
              ?.map((key, value) => MapEntry(key.toLowerCase(), value))
              .containsKey('deviceid') ??
          false)
      ? call.clientMetadata
          ?.map((key, value) => MapEntry(key.toLowerCase(), value))['deviceid']
          ?.trim()
      : null;
}
