import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  late final Isar _db;
  @override
  void init() {
    final name = Platform.environment['DB_NAME'];
    final directory = Platform.environment['DB_DIRECTORY'];
    Isar.open([SessionEntitySchema],
            name: name ?? 'default', directory: directory)
        .then((value) => _db = value);
  }
}
