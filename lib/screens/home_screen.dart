import 'package:flutter/material.dart';
import 'portfolio_screen.dart';
import 'watchlist_screen.dart';
import 'stocks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const StocksScreen(),       // Main stocks listing
    const PortfolioScreen(),    // Holdings view
    const WatchlistScreen(),    // Watchlist view
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.show_chart),
      label: 'Stocks',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet),
      label: 'Portfolio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star_border),
      label: 'Watchlist',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
      ),
    );
  }
}
