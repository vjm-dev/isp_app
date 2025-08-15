class Validators {
  static bool email(String input) {
    return RegExp(
      r'^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    ).hasMatch(input);
  }

  static bool password(String input) {
    return input.length >= 8;
  }

  static bool strongPassword(String input) {
    return input.length >= 8 &&
          RegExp(r'[A-Z]').hasMatch(input) &&
          RegExp(r'[0-9]').hasMatch(input);
  }
}