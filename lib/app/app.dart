import 'package:flutter/material.dart';

/// Root widget of the app.
///
/// Theme, routing and dependency injection are wired in here as the
/// matching phases land.
class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'YumQuick',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('YUMQUICK'),
        ),
      ),
    );
  }
}
