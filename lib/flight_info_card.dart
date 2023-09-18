import 'package:flutter/material.dart';

class FlightInfoCard extends StatelessWidget {
  final String? destination;
  final String? gate;
  final DateTime timeUTC;

  final Color color;

  const FlightInfoCard({
    super.key,
    required this.color,
    this.destination,
    required this.timeUTC,
    this.gate,
  });

  //TODO: Implement cases for daylight savings
  String timeAsStringAnd24hrFormat() {
    DateTime localTime = timeUTC.add(const Duration(hours: 2));
    return '${localTime.hour.toString().padLeft(2, "0")}:${localTime.minute.toString().padLeft(2, "0")}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(destination ?? '??'),
            Text(timeAsStringAnd24hrFormat()),
            Text(gate ?? '??'),
          ],
        ),
      ),
    );
  }
}
