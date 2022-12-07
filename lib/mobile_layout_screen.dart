import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/features/auth/controller/auth_controller.dart';
import 'package:on_messenger/features/configuration/configuration_page.dart';
import 'package:on_messenger/features/search_contacts/screen/page_contact.dart';
import 'package:on_messenger/features/chat/widgets/contacts_list.dart';
import 'package:on_messenger/features/auth/repository/logout_repository.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:on_messenger/features/status/screens/status_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  LogoutRepository logoutRepository = LogoutRepository();

  @override
  void initState() {
    ref.read(authControllerProvider).setUserState(true);
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    ref.read(authControllerProvider).setUserState(false);
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _setState(context) {
    logoutRepository.logout(context);
    ref.read(authControllerProvider).setUserState(false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ContactsList(),
    FeedScreen(),
    PageContact(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        appBar: AppBar(
          elevation: 5,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'On Messenger',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Configurações',
                  ),
                  onTap: () => Future(
                    () => Navigator.pushNamed(
                      context,
                      Configuration.routeName,
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: const Text(
                    'Sair',
                  ),
                  onTap: () => Future(
                    () => _setState(context),
                  ),
                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 50.0,
          items: const <Widget>[
            Icon(Icons.chat, size: 30),
            Icon(Icons.assignment_turned_in_rounded, size: 30),
            Icon(Icons.contacts, size: 30),
          ],
          color: appBarColor,
          buttonBackgroundColor: senderMessageColor,
          backgroundColor: backgroundColor,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            _onItemTapped(index);
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
