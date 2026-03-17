import 'package:kepleomax/core/data/local_data_sources/drafts_local_data_source.dart';

class FakeDraftsLocalDataSource implements DraftsLocalDataSource {
  @override
  Future<void> insert({required String text, required int chatId}) async {}

  @override
  Future<String?> getByChatId(int chatId) async => null;

  @override
  Future<void> deleteByChatId(int chatId) async {}
}
