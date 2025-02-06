import 'package:flutter/material.dart';

class NavMenu extends StatefulWidget {
  final Widget parent;

  const NavMenu({required this.parent, super.key});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  Widget buildNavMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).popUntil(
                (route) {
                  return route.isFirst;
                },
              );
            },
            child: Text('Home Page')),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // show snackbar after 1 frame
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: buildNavMenu(context), duration: Duration(days: 365)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.parent;
  }
}
