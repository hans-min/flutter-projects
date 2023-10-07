import 'package:flutter/material.dart';
import 'package:myoty/screen/login_page/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    required this.appName,
    super.key,
    this.gradientColors = const [Color(0xFF2D79E6), Color(0xFF053476)],
  });
  final List<Color> gradientColors;
  final String appName;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final paddingTop = height > 700 ? 150 : 40;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            //stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Column(
              //physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: paddingTop.toDouble(), bottom: 5),
                  child: Image.asset(
                    "assets/myoty_logo.jpg",
                    scale: 1.5,
                  ),
                ),
                Text(
                  appName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
                // Text(
                //   "v 1.0",
                //   style: Theme.of(context).textTheme.labelLarge,
                // ),
                const SizedBox(height: 40),
                const LoginForm(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "By AKENSYS",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
