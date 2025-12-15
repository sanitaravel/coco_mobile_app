import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/dashboard.dart';
import 'screens/tutorials.dart';
import 'screens/media.dart';
import 'screens/calendar.dart';
import 'blocs/navigation_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  final PageController _pageController = PageController();

  static const List<Widget> _pages = <Widget>[
    Dashboard(),
    Tutorials(),
    Media(),
    Calendar(),
  ];

  static const List<String> _titles = <String>[
    'Dashboard',
    'Tutorials',
    'Media',
    'Calendar',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'WixMadeforText',
          scaffoldBackgroundColor: Color(0xFFDFE1D3),
        ),
        home: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _pageController.animateToPage(
                state.currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  _titles[state.currentIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: -0.14,
                    color: Color(0xFF73AE50),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.gear),
                    onPressed: () {
                      // TODO: settings
                    },
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: PageView(
                controller: _pageController,
                children: _pages,
              ),
              bottomNavigationBar: Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Color(0xFFDFE1D3),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 7),
                      blurRadius: 15,
                      spreadRadius: 0,
                      color: Color(0xFF6C7242),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.chartBar),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.file),
                      label: 'Tutorials',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.camera),
                      label: 'Media',
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.calendar),
                      label: 'Calendar',
                    ),
                  ],
                  currentIndex: state.currentIndex,
                  selectedItemColor: Color(0xFF73AE50),
                  unselectedItemColor: Color(0xFFB7B8B2),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  iconSize: 36,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onTap: (index) {
                    context.read<NavigationBloc>().add(ChangePage(index));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
