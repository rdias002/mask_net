import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_router.dart';
import '../../data/model/companies.dart';
import '../cubits/home/home_cubit.dart';
import '../widgets/home_companies.dart';
import '../widgets/home_feed.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(), child: const _HomeView());
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeFeedScreen(),
    const CompaniesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_selectedIndex == 0 ? 'Feed' : 'Companies'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            iconSize: 40.0,
            padding: const EdgeInsets.only(right: 16.0),
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              context.router.push(const ProfileRoute());
            },
          ),
        ),
        actions: [
          IconButton(
            iconSize: 30.0,
            padding: const EdgeInsets.only(right: 16.0),
            icon: const Icon(Icons.search),
            onPressed: () {
              context.router.push(SearchPostRoute());
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                context.router.push(CreatePostRoute(companyId: channelGeneral));
              },
              child: const Icon(Icons.add))
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Companies',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
