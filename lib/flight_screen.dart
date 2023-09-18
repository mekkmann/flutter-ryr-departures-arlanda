import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'flight_helper.dart';
import 'package:zuliairtest/flight_info_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const spinKitLoading = SpinKitFadingCircle(
  color: Colors.white,
  size: 50.0,
);

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  dynamic flightData;
  List<FlightInfoCard> cardList = [];

  late DateTime selectedDateTime;

  void getData() async {
    setState(() {
      flightData = [];
    });
    flightData =
        await FlightHelper(selectedDateTime.toString().split(' ')[0], 'ARN')
            .getDeparturesOnDate();
    makeCardListFromData();
  }

  void makeCardListFromData() async {
    List<FlightInfoCard> phCardList = [];

    for (var flight in flightData) {
      DateTime flightUtc =
          DateTime.parse(flight['departureTime']['scheduledUtc']);
      if (flightUtc.compareTo(selectedDateTime) < 0) {
        continue;
      }

      phCardList.add(
        FlightInfoCard(
          color: const Color(0xFF6F6F6F),
          destination: flight['arrivalAirportEnglish'],
          timeUTC: flightUtc,
          gate: flight['locationAndStatus']['gate'],
        ),
      );
    }
    phCardList.sort((a, b) => a.timeUTC.compareTo(b.timeUTC));

    setState(() {
      cardList = phCardList;
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.flight_takeoff_rounded),
        title: const Text('ZuliAIR'),
        actions: <Widget>[
          CupertinoButton(
            child: const Text(
              'Date & Time',
              style: TextStyle(color: Colors.white),
            ),
            // Display a CupertinoDatePicker in time picker mode.
            onPressed: () => _showDialog(
              CupertinoDatePicker(
                initialDateTime: selectedDateTime,
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: true,
                // This is called when the user changes the datetime.
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    //TODO: Make sure getData() only gets called when DATE is changed NOT TIME
                    selectedDateTime = newTime;
                    getData();
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: flightData.length != 0
            ? ListView(children: cardList)
            : spinKitLoading,
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          getData();
        },
        backgroundColor: Colors.white70,
        child: const Icon(CupertinoIcons.arrow_counterclockwise),
      ),
    );
  }
}
