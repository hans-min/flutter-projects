import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myoty/services/shared_pref_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton.icon(
            onPressed: () {
              SharedPrefs.clearWithoutUsername();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                ModalRoute.withName('/'),
              );
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
            ),
            icon: const Icon(CupertinoIcons.square_arrow_left),
            label: const Text("Log Out"),
          ),
        ),
        //   ],
        // ),
      ),
    );
  }
}
