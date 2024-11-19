import 'package:cloudease/features/home/components/drawer.dart';
import 'package:cloudease/features/home/data/home_provider.dart';
import 'package:cloudease/features/home/screens/tabs/dashboard_tab.dart';
import 'package:cloudease/features/home/screens/tabs/courses_tab.dart';
import 'package:cloudease/features/home/screens/tabs/inbox_tab.dart';
import 'package:cloudease/features/home/screens/tabs/teachers_tab.dart';
import 'package:cloudease/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = Provider.of<HomeProvider>(context,listen: false).currentTabIndex;
    super.initState();
  }

  // Screens for each tab
  final List<Widget> _screens = const [
    // Profile(),
    Dashboard(),
    Courses(),
    Inbox(),
    Teachers(),
  ];

  // Icons for each tab
  final List<IconData> _icons = [
    // Icons.person,           // Profile
    Icons.dashboard,        // Dashboard
    Icons.group,            // Groups
    Icons.mail,             // Inbox
    Icons.school,           // Teachers
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    Provider.of<HomeProvider>(context, listen: false).setCurrentTabIndex(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      drawerScrimColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: lightBlue,
        iconTheme: IconThemeData(color: white),
        title: Text(_getLabelForIndex(_currentIndex)),
        titleTextStyle: TextStyle(color: white, fontSize: 17),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue, 
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: List.generate(4, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _getLabelForIndex(index),
          );
        }),
      ),
    );
  }

  // Function to return the label for each tab
  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Courses';
      case 2:
        return 'Inbox';
      case 3:
        return 'Teachers';
      default:
        return '';
    }
  }
}