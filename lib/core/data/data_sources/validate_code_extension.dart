extension ValidateCodeExtension on int {
  bool get is200 => this >= 200 && this <= 299;

  bool get isNot200 => !is200;
}
