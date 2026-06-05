import 'package:kepleomax/core/flavor.dart';

abstract class AppConstants {
  static AppConstantsType get _constants => flavor.constants;

  static final Duration sendActivityDelay = _constants.sendActivityDelay;
  static final Duration markAsOfflineAfterInactivity =
      _constants.markAsOfflineAfterInactivity;
  static final Duration showTypingAfterActivity = _constants.showTypingAfterActivity;
  static final Duration callingTimeout = _constants.callingTimeout;
  static final Duration fakeDelayDuration = _constants.fakeDelayDuration;

  static final int msgPagingLimit = _constants.msgPagingLimit;
  static final int postsPagingLimit = _constants.postsPagingLimit;
  static final int peoplePagingLimit = _constants.peoplePagingLimit;
}

/// TODO make default "release" instead of "develop" (so ovveride only for develop and testing)
/// default constants (for develop). You can override any of these values for release and testing
abstract class AppConstantsType {
  const AppConstantsType();

  /// constructors
  factory AppConstantsType.release() => const _AppConstatsRelease();

  factory AppConstantsType.develop() => const _AppConstatsDevelop();

  factory AppConstantsType.testing() => const _AppConstantsTesting();

  /// fields
  Duration get sendActivityDelay => const Duration(seconds: 30);

  Duration get markAsOfflineAfterInactivity => const Duration(seconds: 60);

  Duration get showTypingAfterActivity => const Duration(seconds: 3);

  Duration get callingTimeout => const Duration(seconds: 15);

  Duration get fakeDelayDuration => const Duration(milliseconds: 300);

  int get msgPagingLimit => 15;

  int get postsPagingLimit => 5;

  int get peoplePagingLimit => 12;
}

/// types
class _AppConstatsRelease extends AppConstantsType {
  const _AppConstatsRelease();

  @override
  Duration get showTypingAfterActivity => const Duration(seconds: 5);

  @override
  Duration get callingTimeout => const Duration(seconds: 45);

  @override
  int get msgPagingLimit => 30;
}

class _AppConstatsDevelop extends AppConstantsType {
  const _AppConstatsDevelop() : super();
  // no overrides
}

class _AppConstantsTesting extends AppConstantsType {
  const _AppConstantsTesting() : super();

  @override
  Duration get showTypingAfterActivity => const Duration(seconds: 1);

  @override
  Duration get fakeDelayDuration => Duration.zero;
}
