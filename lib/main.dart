import 'package:flutter/material.dart';
import 'package:flutter_personal_diary_for_visually_impaired/screens/SettingScreen.dart';
import 'package:flutter_personal_diary_for_visually_impaired/services/UiProvider.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(

            debugShowCheckedModeBanner: false,

            //By default theme setting, you can also set system
            // when your mobile theme is dark the app also become dark

            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,

            //Our custom theme applied
            darkTheme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,

            theme: notifier.isDark
                ? notifier.darkTheme // dark theme applied
                : notifier.blueTheme, // pink theme applied when not dark

            home: SettingScreen(title: 'Settings'),

          );
        },
      ),
    );
  }
}