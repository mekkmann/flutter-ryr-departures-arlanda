import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class FlightHelper {
  FlightHelper(this.dateAsString, this.airportIATA);

  String dateAsString;
  String airportIATA;

  //TODO: Refactor getDeparturesOnDate()
  //Better parsing?
  //Parse to classes? (could give easier querying)
  Future getDeparturesOnDate() async {
    http.Response response = await http.get(
        Uri.parse(
            'https://api.swedavia.se/flightinfo/v2/$airportIATA/departures/$dateAsString'),
        headers: {
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
          'Ocp-Apim-Subscription-Key': 'YOUR-API-KEY-HERE'
        });

    if (response.statusCode != 200) {
      log('LOG - [ HTTP ERROR: ${response.statusCode} ]');
      return;
    } else {
      var decodedData = jsonDecode(response.body);
      var ryanFlights = [];
      for (var flight in decodedData['flights']) {
        if (flight['locationAndStatus']['flightLegStatusEnglish'] ==
            'Deleted') {
          continue;
        }
        if (flight['airlineOperator']['name'] == 'Ryanair Ltd') {
          ryanFlights.add(flight);
        }
      }
      return ryanFlights;
    }
  }
}
