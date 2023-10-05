import 'package:flutter/material.dart';

class FadePageRouteBuilder extends PageRouteBuilder {
  final Widget page;
  FadePageRouteBuilder({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 700),
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return page;
    },
  );
}