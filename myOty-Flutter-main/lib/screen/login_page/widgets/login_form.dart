import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myoty/model/networks.dart';
import 'package:myoty/screen/login_page/network_list.dart';
import 'package:myoty/screen/login_page/widgets/email_field.dart';
import 'package:myoty/screen/login_page/widgets/password_field.dart';
import 'package:myoty/screen/navigation_bar/bottom_navigation_bar_5.dart';
import 'package:myoty/services/http.dart';
import 'package:myoty/services/shared_pref_manager.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (SharedPrefs.username != null) {
      _usernameController.text = SharedPrefs.username!;
    }
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            EmailField(
              submitted: submitted,
              controller: _usernameController,
            ),
            const SizedBox(height: 20),
            PasswordField(
              submitted: submitted,
              controller: _passwordController,
              onSubmittedLogin: login,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: login,
              icon: const Icon(Icons.account_circle),
              label: const Text("Login"),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                fixedSize: MaterialStateProperty.all(const Size(270, 50)),
                // shadowColor: MaterialStateColor.resolveWith(
                //   (states) => Colors.red,
                // ),
              ),
            ),
            TextButton(
              onPressed: () {
                //Forgot password screen
              },
              child: Text(
                "Forget password ?",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      _formKey.currentState!.save();
      submitted = true;
    });
    if (_formKey.currentState!.validate()) {
      TextInput.finishAutofillContext();
      showProgressIndicator();
      await fetchNetworkListAndNavigate();
    }
  }

  void showProgressIndicator() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // Circular progress indicator
        );
      },
    );
  }

  Future<void> fetchNetworkListAndNavigate() async {
    await API
        .fetchSession(_usernameController.text, _passwordController.text)
        .then((session) {
      final networks = session.networks;
      Navigator.of(context).pop();
      Navigator.of(context).push(
        navigateToNetwork(networks),
      );
    }).catchError((Object err) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    });
  }

  MaterialPageRoute<void> navigateToNetwork(List<Networks> networks) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) {
        if (networks.length == 1) {
          //TODO(hai): Wait for network logo
          SharedPrefs.networkID = networks[0].network.id;
          SharedPrefs.networkColor = networks[0].network.primaryColor;
          return const BotNavBar();
        } else {
          return NetworkListPage(
            networks: networks,
          );
        }
      },
    );
  }
}
