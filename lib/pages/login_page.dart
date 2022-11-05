import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:student_record_mangement/utils/signinprovider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? emailError;
  String? passError;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignIn>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Page'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Enter Email',
                errorText: emailError,
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              onChanged: (text) {
                setState(() {
                  if (EmailValidator.validate(text)) {
                    emailError = null;
                  } else {
                    emailError = 'Enter a Valid Email';
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: TextField(
              controller: password,
              decoration: InputDecoration(
                hintText: 'Enter password',
                errorText: passError,
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (text) {
                setState(() {
                  if (text.length >= 8) {
                    passError = null;
                  } else {
                    passError = 'Enter At least 8 characters';
                  }
                });
              },
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: ElevatedButton(
                onPressed: () {
                  provider.loginWithEmailPassword(email.value.text, password.value.text);
                },
                child: const Text('Login'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
