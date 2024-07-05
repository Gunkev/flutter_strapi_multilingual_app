import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/profile.dart';
import '../screens/requestRecipe.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isAuthenticated = false;
  String? _username;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAuthenticated = prefs.containsKey('jwt');
      _username = prefs.getString('username');
      _userId = prefs.getString('userId');
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isAuthenticated = false;
      _username = null;
      _userId = null;
    });
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _changeLanguage(Locale locale) {
    context.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              _isAuthenticated ? tr('hello', namedArgs: {'username': _username ?? ''}) : tr('welcome'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (_isAuthenticated)
            ListTile(
              leading: Icon(Icons.request_page),
              title:Text(tr('request_recipe')),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeRequestScreen()),

                );
              },
            ),
          if (_isAuthenticated)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(tr('profile')),
              onTap: () {
                if (_userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }
              },
            ),
          if (_isAuthenticated)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(tr('logout')),
              onTap: _logout,

            )
          else
            ListTile(
              leading: Icon(Icons.login),
              title: Text(tr('login')),
              onTap: _navigateToLogin,
            ),
          Divider(),
          ListTile(
            leading: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Image.asset(
                'assets/images/en-flag.jpg',
              ),
            ),
            title: Text(tr('english')),
            onTap: () {
              Navigator.pop(context);
              _changeLanguage(Locale('en'));
    },
          ),
          ListTile(
            leading: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Image.asset(
                'assets/images/fr-flag.jpg',
              ),
            ),
            title: Text(tr('french')),
            onTap: () {
              Navigator.pop(context);
              _changeLanguage(Locale('fr', 'FR'));
            },
          ),
          ListTile(
            leading: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Image.asset(
                'assets/images/ja-flag.jpg',
              ),
            ),
            title: Text(tr('japanese')),
            onTap: () {
              Navigator.pop(context);
              _changeLanguage(Locale('ja', 'JP'));
            },
          ),
        ],
      ),
    );
  }
}
