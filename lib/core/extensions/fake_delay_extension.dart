import 'package:kepleomax/core/app_constants.dart';

extension FutureFakeDelayExtension<T> on Future<T> {
  Future<T> withFakeDelay({Duration? minDuration}) async {
    final fakeDelay = Future<void>.delayed(
      minDuration ?? AppConstants.fakeDelayDuration,
    );

    final result = await this;

    await fakeDelay;

    return result;
  }
}
