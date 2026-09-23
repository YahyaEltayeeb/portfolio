import 'package:flutter/material.dart';

/// A custom PageRoute that performs a smooth fade transition.
class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration transitionDurationCustom;

  FadeRoute({
    required this.page,
    this.transitionDurationCustom = const Duration(milliseconds: 400),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: transitionDurationCustom,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: CurvedAnimation(
               parent: animation,
               curve: Curves.easeInOut,
             ),
             child: child,
           );
         },
       );
}
