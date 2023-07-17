import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  //final Key key;
  final bool isSelected;
  final int exampleNumber;
  final VoidCallback onPressed;

  const Button({
    //  required this.key,
    required this.isSelected,
    required this.exampleNumber,
    required this.onPressed,
  }); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: isSelected ? Colors.grey : Colors.grey[800],
        child: Text(exampleNumber.toString(),
            style: TextStyle(color: Colors.white)),
        onPressed: () {
          Scrollable.ensureVisible(
            context,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeOut,
            alignment: 0.5,
          );
          onPressed();
        });
  }
}
//////////////////////////////////////////////////