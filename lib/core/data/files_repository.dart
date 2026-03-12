import 'dart:io';

import 'package:kepleomax/core/data/data_sources/files_api_data_source.dart';

abstract class FilesRepository {
  Future<String> uploadFile(String path);
}

class FilesRepositoryImpl implements FilesRepository {
  FilesRepositoryImpl({required FilesApiDataSource filesApiDataSource})
    : _filesApiSource = filesApiDataSource;
  final FilesApiDataSource _filesApiSource;

  @override
  Future<String> uploadFile(String path) => _filesApiSource.uploadFile(File(path));
}
