import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/dummy_data/dummy_data.dart';
import 'package:week_3_blabla_project/theme/theme.dart';
import 'package:week_3_blabla_project/widgets/actions/bla_button.dart';
import 'package:week_3_blabla_project/widgets/inputs/bla_input.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';

class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  @override
  void initState() {
    super.initState();
     //TODO: 
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlaInput(
          labelText: 'From',
          iconForm: Icons.circle_outlined,
          onTap: () => print('you tapped'),
          iconSwitching: Icons.swap_vert,
        ),
        BlaInput(
          labelText: 'Going to',
          iconForm: Icons.circle_outlined,
          onTap: () => print('you tapped'),
        ),
        BlaInput(
          labelText: 'Departure date',
          iconForm: Icons.date_range_sharp,
          onTap: () => print('you tapped'),
        ),
        BlaInput(
          labelText: '1',
          iconForm: Icons.person,
          onTap: () => print('you tapped'),
        ),
        BlaButton(
          text: 'Search',
          onPressed: () => print('you searched'),
        ),
      ],
    );
  }
}
