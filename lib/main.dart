import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'flight_screen.dart';

void main() {
  runApp(const ZuliAir());
}

class ZuliAir extends StatelessWidget {
  const ZuliAir({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      theme: ThemeData.dark(),
      home: const FlightScreen(),
    );
  }
}
