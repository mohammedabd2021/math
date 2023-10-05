import 'package:flutter/material.dart';

class SlidePageRouteBuilder extends PageRouteBuilder {
  final Widget page;
  SlidePageRouteBuilder({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 700),
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return page;
    },
  );
}