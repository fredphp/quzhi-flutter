import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quzhi_app/providers/app_provider.dart';
import 'package:quzhi_app/providers/notification_provider.dart';
import 'package:quzhi_app/providers/address_provider.dart';
import 'package:quzhi_app/utils/theme.dart';
import 'package:quzhi_app/pages/login_page.dart';
import 'package:quzhi_app/pages/index_page.dart';

void main() {
  runApp(const QuZhiApp());
}

class QuZhiApp extends StatelessWidget {
  const QuZhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: MaterialApp(
        title: '趣知',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/': (context) => const IndexPage(),
        },
      ),
    );
  }
}
