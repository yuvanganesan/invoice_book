import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

  // : super(
  //     pageBuilder: (
  //       BuildContext context,
  //       Animation<double> animation,
  //       Animation<double> secondaryAnimation,
  //     ) =>
  //         page,
  //     transitionsBuilder: (
  //       BuildContext context,
  //       Animation<double> animation,
  //       Animation<double> secondaryAnimation,
  //       Widget child,
  //     ) =>
  //         SlideTransition(
  //       position: Tween<Offset>(
  //         begin: const Offset(-1, 0),
  //         end: Offset.zero,
  //       ).animate(animation),
  //       child: child,
  //     ),
  //   );
}
