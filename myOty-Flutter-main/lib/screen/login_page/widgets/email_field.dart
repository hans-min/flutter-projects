import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    required this.submitted,
    required this.controller,
    super.key,
  });
  final bool submitted;
  final TextEditingController controller;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        textInputAction: TextInputAction.next,
        controller: widget.controller,
        decoration: const InputDecoration(
          errorStyle: TextStyle(color: Colors.deepOrange),
          filled: true,
          fillColor: Colors.white,
          labelText: "Email",
          prefixIcon: Icon(Icons.person),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: widget.submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          } else if (!isValidEmail(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }
}
