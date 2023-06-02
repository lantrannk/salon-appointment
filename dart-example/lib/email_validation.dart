// Implement a simple EmailAddress class that takes an email String as a constructor argument.
// This class should throw a FormatException if:
// - it is initialized with an empty email
// - the email doesn't contain a @ character

void main() {
  try {
    print(EmailAddress('me@example.com'));
    print(EmailAddress('example.com'));
    print(EmailAddress(''));
  } on FormatException catch (e) {
    print(e);
  }
}

class EmailAddress {
  String email;

  EmailAddress(this.email) {
    if (email.isEmpty) {
      throw FormatException('Email can\'t be empty.');
    }
    if (!email.contains('@')) {
      throw FormatException('$email doesn\'t contain the @ symbol');
    }
  }

  @override
  String toString() => email;
}
