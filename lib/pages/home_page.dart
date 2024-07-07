import 'package:flutter/material.dart';
import 'package:namer_app/pages/community/community_page.dart';
import 'package:namer_app/pages/events/calender_page.dart';
import 'package:namer_app/pages/gifts_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 0;
  static const Color middleColor = Color(0xFFCD6600);
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_currentIndex) {
      case 0:
        page = GiftPage();
      case 1:
        page = CommunityPage();
      case 2:
        page = CalendarPage();
      default:
        throw UnimplementedError('no widget for $_currentIndex');
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: page,
            ),
          ),
          SafeArea(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: middleColor,
                  icon: Icon(Icons.card_giftcard, color: middleColor),
                  label: 'Gift',
                ),
                BottomNavigationBarItem(
                  backgroundColor: middleColor,
                  icon: Icon(Icons.group, color: middleColor),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  backgroundColor: middleColor,
                  icon: Icon(Icons.calendar_month_sharp, color: middleColor),
                  label: 'Calender',
                ),
              ],
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
