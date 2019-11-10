import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {

  FadeRoute({ WidgetBuilder builder, RouteSettings settings})
  :super(builder: builder, settings: settings);

  @override
  Widget buildTransaction(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if (settings.isInitialRoute) return child;

    // Fade between routes. (Return child if not need animation)
    return new FadeTransition(opacity: animation, child: child);
  }
}