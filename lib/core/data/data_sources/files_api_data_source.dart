import 'dart:io';

import 'package:kepleomax/core/network/apis/files/files_api.dart';

abstract class FilesApiDataSource {
  Future<String> uploadFile(File file);
}

class FilesApiDataSourceImpl implements FilesApiDataSource {
  FilesApiDataSourceImpl({required FilesApi filesApi}) : _api = filesApi;

  final FilesApi _api;

  @override
  Future<String> uploadFile(File file) async {
    final imageRes = await _api.uploadFile(file);

    if (imageRes.response.statusCode != 201) {
      throw Exception(
        imageRes.data.message ??
            'Failed to upload image: ${imageRes.response.statusCode}',
      );
    }

    return imageRes.data.data!.path;
  }
}
