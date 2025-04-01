import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/screens/home.dart';
import 'package:flutter_recipe_app/screens/login.dart';
import 'package:flutter_recipe_app/screens/requestRecipe.dart';
import 'package:flutter_recipe_app/screens/signUp.dart';
import 'package:flutter_recipe_app/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// app main
Future<void> main() async{
  // Ensure all bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('fr', 'FR'),
      Locale('ja', 'JP')],
    path: 'assets/translations', //
    fallbackLocale: Locale('en'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
      ],
      child: MaterialApp(
        title: tr('app_description'),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/home',
        routes: {
          '/request': (context) => RecipeRequestScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(), // Implement HomeScreen
        },
      ),
    );
  }
}
