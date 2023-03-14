import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/repositories/repositories.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  late final Isar _db;
  @override
  Future<void> init() {
    final name = Platform.environment['DB_NAME'];
    final directory = Platform.environment['DB_DIRECTORY'];
    return Isar.open([], name: name ?? 'default', directory: directory)
        .then((value) => _db = value);
  }
}
