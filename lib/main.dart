import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard.dart';
import 'tutorials.dart';
import 'media.dart';
import 'calendar.dart';
import 'navigation_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const List<Widget> _pages = <Widget>[
    Dashboard(),
    Tutorials(),
    Media(),
    Calendar(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc(),
      child: MaterialApp(
        home: Scaffold(
          body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              return _pages[state.currentIndex];
            },
          ),
          bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              return BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.book),
                    label: 'Tutorials',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.photoFilm),
                    label: 'Media',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.calendar),
                    label: 'Calendar',
                  ),
                ],
                currentIndex: state.currentIndex,
                onTap: (index) {
                  context.read<NavigationBloc>().add(ChangePage(index));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
