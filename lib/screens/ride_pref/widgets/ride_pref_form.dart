import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/dummy_data/dummy_data.dart';
import 'package:week_3_blabla_project/screens/ride_pref/test_screen.dart';
import 'package:week_3_blabla_project/theme/theme.dart';
import 'package:week_3_blabla_project/widgets/actions/bla_button.dart';
import 'package:week_3_blabla_project/widgets/inputs/bla_input.dart';
import 'package:week_3_blabla_project/utils/animations_util.dart';

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

  TextEditingController inputController = TextEditingController();
  List<Location> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    departure = widget.initRidePref?.departure;
    departureDate = widget.initRidePref?.departureDate ?? DateTime.now();
    arrival = widget.initRidePref?.arrival;
    requestedSeats = widget.initRidePref?.requestedSeats ?? 1;
    filteredLocations = [];
  }

  void _openFullScreenDialog(BuildContext context, Function(Location) onLocationSelected) {
    setState(() {
      filteredLocations = []; // Reset list
    });
    Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(
        StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: BlaColors.white,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios, color: BlaColors.neutralLight),
                ),
                title: TextField(
                  controller: inputController,
                  onChanged: (text) {
                    setDialogState(() {
                      filteredLocations = fakeLocations
                          .where((location) => location.name
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search location',
                    border: InputBorder.none,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      inputController.clear();
                      setDialogState(() {
                        filteredLocations = [];
                      });
                    },
                    icon: Icon(Icons.close, color: BlaColors.neutralLight),
                  ),
                ],
              ),
              body: filteredLocations.isEmpty
                  ? const Center(child: Text("No results found"))
                  : ListView.builder(
                      itemCount: filteredLocations.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: BlaColors.greyLight,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.location_on, color: BlaColors.neutralLight, size: 20),
                            title: Text(filteredLocations[index].name),
                            subtitle: Text(filteredLocations[index].country.name),
                            trailing: Icon(Icons.arrow_forward_ios, color: BlaColors.neutralLight, size: 16),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                onLocationSelected(filteredLocations[index]);
                              });
                            },
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  // Function to swap the departure and arrival locations
  void _swapLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlaInput(
            labelText: departure?.name ?? 'From',
            iconForm: Icons.circle_outlined,
            onTap: () => _openFullScreenDialog(context, (location) {
              setState(() {
                departure = location;
              });
            }),
            iconSwitching: Icons.swap_vert,
            onPressed: _swapLocations,
          ),
          BlaInput(
            labelText: arrival?.name ?? 'Going to',
            iconForm: Icons.circle_outlined,
            onTap: () => _openFullScreenDialog(context, (location) {
              setState(() {
                arrival = location;
              });
            }),
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(
              departure: departure,
              arrival: arrival,
            ))),
          ),
        ],
      ),
    );
  }
}
