import 'package:kepleomax/core/app_constants.dart';

Flavor? _flavor;

Flavor get flavor => _flavor ?? Flavor.devLocal();

class Flavor {
  Flavor({
    required this.baseUrl,
    required this.imageUrl,
    required this.type,
    required this.constants,
  }) : assert(baseUrl.isNotEmpty, "baseUrl can't be empty"),
       assert(imageUrl.isNotEmpty, "imageUrl can't be empty");

  factory Flavor.release() => Flavor(
    baseUrl: 'http://127.0.0.1:13000',
    imageUrl: 'http://10.0.2.2:13000/api/files/',
    type: FlavorType.release,
    constants: AppConstantsType.release(),
  );

  factory Flavor.devPublic() => Flavor(
    baseUrl: 'http://34.118.78.192:13000',
    imageUrl: 'http://34.118.78.192:13000/api/files/',
    type: FlavorType.develop,
    constants: AppConstantsType.develop(),
  );

  factory Flavor.devLocal() => Flavor(
    baseUrl: 'http://192.168.0.104:13000',
    imageUrl: 'http://192.168.0.104:13000/api/files/',
    type: FlavorType.develop,
    constants: AppConstantsType.develop(),
  );

  factory Flavor.testing() => Flavor(
    baseUrl: '_no_urls_in_tests_',
    imageUrl: '_no_urls_in_tests_',
    type: FlavorType.testing,
    constants: AppConstantsType.testing(),
  );

  final String baseUrl;
  final String imageUrl;
  final FlavorType type;
  final AppConstantsType constants;

  bool get isDevelop => type == FlavorType.develop;

  bool get isRelease => type == FlavorType.release;

  bool get isTesting => type == FlavorType.testing;

  /// name for the argument shouldn't be flavor, cause IDE automatically will
  /// write setFlavor(flavor);
  /// this won't have errors cause flavor - will be taken from this file (flavor.dart)
  /// it may create some room for mistakes
  static void setFlavor(Flavor fv) => _flavor = fv;
}

enum FlavorType { develop, release, testing }
