import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expensetracker/pages/home_page.dart';
import 'package:expensetracker/pages/metric_category_page.dart';
import 'package:expensetracker/pages/metric_graph_page.dart';
import 'package:expensetracker/provider/user_provider.dart';
import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(expenseListProvider.notifier).addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text('Hi, ${ref.watch(userProvider).getUsername}!',
                style: TextStyle(
                  fontSize: 56,
                  color: Colors.white,
                  fontFamily: GoogleFonts.justAnotherHand().fontFamily,
                )),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
              icon: const Icon(Icons.settings_outlined,
                  color: Colors.white60, size: 30))
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const <Widget>[
          HomePage(),
          MetricCategoryScreen(),
          MetricGraphScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(243, 31, 31, 31),
        buttonBackgroundColor: const Color.fromARGB(243, 55, 55, 55),
        height: 50,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
