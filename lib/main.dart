// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/watchlist_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const InvestMateApp());
}

class InvestMateApp extends StatelessWidget {
  const InvestMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: MaterialApp(
        title: 'InvestMate',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
// lib/screens/login_screen.dart