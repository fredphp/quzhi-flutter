import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:quzhi_app/providers/notification_provider.dart';
import 'package:quzhi_app/providers/address_provider.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/pages/login_page.dart';
import 'package:quzhi_app/pages/index_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuZhiApp());
}

class QuZhiApp extends StatefulWidget {
  const QuZhiApp({super.key});

  @override
  State<QuZhiApp> createState() => _QuZhiAppState();
}

class _QuZhiAppState extends State<QuZhiApp> {
  final AppProvider _appProvider = AppProvider();
  bool _initialized = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _appProvider.checkLogin();
    setState(() {
      _isLoggedIn = loggedIn;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFFA726), Color(0xFFFFD166)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('趣',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900)),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appProvider),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: MaterialApp(
        title: '趣知',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: _isLoggedIn ? '/' : '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/': (context) => const IndexPage(),
        },
      ),
    );
  }
}
