import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'screens/dashboard.dart';
import 'screens/tutorials.dart';
import 'screens/media.dart';
import 'screens/calendar.dart';
import 'screens/login.dart';
import 'blocs/navigation_bloc.dart';
import 'blocs/tasks_cubit.dart';
import 'blocs/auth_cubit.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  final PageController _pageController = PageController();
  bool _globalLoadingShown = false;

  static final List<Widget> _pages = <Widget>[
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'WixMadeforText',
        scaffoldBackgroundColor: const Color(0xFFDFE1D3),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
          BlocProvider<TasksCubit>(create: (_) => TasksCubit()),
          BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthService())),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isLoading && !_globalLoadingShown) {
              _globalLoadingShown = true;
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                useRootNavigator: true,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
              return;
            }

            if (!state.isLoading && _globalLoadingShown) {
              _globalLoadingShown = false;
              if (Navigator.canPop(context)) Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState.isLoading) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (authState.user == null) {
                return const LoginPage();
              }
              return BlocBuilder<NavigationBloc, NavigationState>(
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
                        style: const TextStyle(
                          fontFamily: 'WixMadeforText',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: -0.14,
                          color: Color(0xFF73AE50),
                        ),
                      ),
                      actions: [
                        PopupMenuButton<String>(
                          icon: const FaIcon(FontAwesomeIcons.gear),
                          onSelected: (value) {
                            if (value == 'logout') {
                              context.read<AuthCubit>().signOut();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              enabled: false,
                              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance.collection('users').doc(authState.user!.uid).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox(width: 220, height: 64, child: Center(child: CircularProgressIndicator()));
                                  }
                                  final data = snapshot.data!.data() ?? {};
                                  final fullName = (data['displayName'] as String?) ?? authState.user?.displayName ?? '';
                                  final email = (data['email'] as String?) ?? authState.user?.email ?? '';
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        fullName,
                                        style: const TextStyle(
                                          fontFamily: 'WixMadeforText',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontFamily: 'WixMadeforText',
                                          fontSize: 12,
                                          color: Color(0xFF6B6B6B),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'logout',
                              child: Row(
                                children: const [
                                  Icon(Icons.logout, color: Color(0xFF73AE50)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Log out',
                                    style: TextStyle(color: Color(0xFF73AE50)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    body: PageView(controller: _pageController, physics: const NeverScrollableScrollPhysics(), children: _pages),
                    bottomNavigationBar: Container(
                      height: 89,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDFE1D3),
                        boxShadow: [BoxShadow(offset: Offset(0, 7), blurRadius: 15, spreadRadius: 0, color: Color(0xFF6C7242))],
                      ),
                      child: BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.chartBar), label: 'Dashboard'),
                          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.file), label: 'Tutorials'),
                          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.camera), label: 'Media'),
                          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.calendar), label: 'Calendar'),
                        ],
                        currentIndex: state.currentIndex,
                        selectedItemColor: const Color(0xFF73AE50),
                        unselectedItemColor: const Color(0xFFB7B8B2),
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        selectedLabelStyle: const TextStyle(
                          fontFamily: 'WixMadeforText',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: -0.12,
                          color: Color(0xFF73AE50),
                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
