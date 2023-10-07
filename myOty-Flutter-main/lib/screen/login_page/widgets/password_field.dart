import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.submitted,
    required this.controller,
    required this.onSubmittedLogin,
    super.key,
  });
  final TextEditingController controller;
  final bool submitted;
  final void Function() onSubmittedLogin;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  //late TextEditingController passwordController;
  bool _obscure = true;
  late Icon _icon = const Icon(Icons.visibility_off);

  // @override
  // void initState() {
  //   passwordController = widget.passwordController;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        textInputAction: TextInputAction.go,
        onFieldSubmitted: (value) => widget.onSubmittedLogin(),
        autofillHints: const [AutofillHints.password],
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: "Password",
          errorStyle: const TextStyle(color: Colors.deepOrange),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () => setState(() {
              _obscure = !_obscure;
              _icon = _obscure
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility);
            }),
            icon: _icon,
          ),
          border: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        obscureText: _obscure,
        autocorrect: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          } else if (value.length < 3) {
            return 'Password must be at least 3 characters';
          }
          return null;
        },
        autovalidateMode: widget.submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
      ),
    );

    // bool isStrongPassword(String password) {
    //   return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
    //       .hasMatch(password);
    // }
  }
}
