import 'package:flutter/material.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: TabBar(tabs: [
            Tab(
              text: 'Worker',
            ),
            Tab(
              text: 'Manager',
            )
          ]),
          body: TabBarView(children: [Container(), Container()]),
        ));
  }
}
