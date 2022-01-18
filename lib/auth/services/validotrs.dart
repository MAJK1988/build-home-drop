class Validator {
  static bool checkEmpty(String? name, String? password,
      [String? passwordConfirm]) {
    if (name == null || password == null) {
      return false;
    }
    if (name.isEmpty || password.isEmpty) {
      return false;
    } else {
      if (passwordConfirm == null)
        return true;
      else
        return true && !passwordConfirm.isEmpty;
    }
  }

  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return '';
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Password length is at least 6';
    }

    return '';
  }

  static bool confirmPassword(
      {required String? password, required String? confirmPassword}) {
    if (password == confirmPassword) {
      return true;
    } else
      return false;
  }
}
