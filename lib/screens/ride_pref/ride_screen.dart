import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';
import 'package:week_3_blabla_project/theme/theme.dart';

class RideScreen extends StatelessWidget {
  final Location? departure;
  final Location? arrival;
  final String date;
  final int seatCount;
  RideScreen(
      {super.key,
      required this.departure,
      required this.arrival,
      required this.date,
      required this.seatCount
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BlaColors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: BlaColors.neutralLight),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search location',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.close, color: BlaColors.neutralLight),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: BlaColors.greyLight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Departure: ${departure?? 'Not selected'}'),
                    Text('Arrival: ${arrival ?? 'Not selected'}'),
                    Text('Departure: ${date}'),
                    Text('Requested Seats: ${seatCount??'Not selected'}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
