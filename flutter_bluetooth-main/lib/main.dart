import 'package:bluetooth/bluetooth_page.dart';
import 'package:bluetooth/utilities.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Utilities.loadCompanyIdentifiers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeData.copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: themeData.colorScheme.primary),
          bodySmall: TextStyle(
              color: themeData.colorScheme.onSurface.withOpacity(0.7)),
        ),
      ),
      home: const BluetoothScanPage(),
    );
  }
}
