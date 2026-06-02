import 'package:kepleomax/core/app_constants.dart';

extension FutureFakeDelayExtension<T> on Future<T> {
  Future<T> withFakeDelay({Duration? minDuration}) async {
    if (minDuration != null && minDuration.isNegative) {
      throw Exception('minDuration must be positive');
    }

    final fakeDelay = Future<void>.delayed(
      minDuration ?? AppConstants.fakeDelayDuration,
    );

    final result = await this;

    await fakeDelay;

    return result;
  }
}
