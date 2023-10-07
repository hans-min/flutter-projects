import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myoty/screen/login_page/login_page.dart';
import 'package:myoty/screen/navigation_bar/bottom_navigation_bar_5.dart';
import 'package:myoty/services/shared_pref_manager.dart';
import 'package:myoty/utils/extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  final networkID = SharedPrefs.networkID;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp(networkID: networkID)));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.networkID});
  final String? networkID;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      onThemeUpdated: (newTheme) {
        setState(() {
          primaryColor = newTheme;
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //useMaterial3: true,
          colorScheme: ColorScheme.light(primary: primaryColor),
          textTheme: const TextTheme(
            labelLarge: TextStyle(color: Colors.white),
          ),
          primaryTextTheme: Typography.whiteCupertino,
          popupMenuTheme: PopupMenuThemeData(
            elevation: 3,
            color: Colors.white,
            textStyle: TextStyle(color: primaryColor),
          ),
          listTileTheme: ListTileThemeData(
            selectedColor: HexColor.getComplementaryColor(primaryColor),
            selectedTileColor: Colors.grey[200],
          ),
        ),
        initialRoute: widget.networkID == null ? '/login' : '/botnavbar',
        routes: {
          '/login': (context) => const LoginPage(appName: 'MyOty'),
          '/botnavbar': (context) => const BotNavBar(),
        },
      ),
    );
  }
}

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({
    required super.child,
    required this.onThemeUpdated,
    super.key,
  });
  final ValueChanged<Color> onThemeUpdated;

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) => false;

  static ThemeProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeProvider>();

  static ThemeProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No NetworkColor found in context');
    return result!;
  }

  void updateTheme(Color color) {
    onThemeUpdated(color);
  }
}

class ThemeColor with ChangeNotifier {
  //final Color =
}
