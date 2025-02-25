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
    requestedSeats = widget.initRidePref!.requestedSeats;
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
                          .where((location) => location.name.toLowerCase().contains(text.toLowerCase()))
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
                        return ListTile(
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
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  void _swapLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  void _showNumberSpinnerDialog(BuildContext context) {
    Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(
        StatefulBuilder(
          builder: (context, setDialogState) {
            int seatCount = requestedSeats;
            return Scaffold(
              backgroundColor: BlaColors.white,
              appBar: AppBar(
                backgroundColor: BlaColors.white,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: BlaColors.neutralLight),
                ),
                title: Text('Select Number of Seats', style: TextStyle(color: BlaColors.neutralDark)),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text("Number of seats to book", style: TextStyle(color: BlaColors.neutralDark, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: BlaColors.neutralLight, size: 40),
                        onPressed: () {
                          if (seatCount > 1) {
                            setDialogState(() {
                              seatCount--;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      Text('$seatCount', style: TextStyle(color: BlaColors.neutralDark, fontSize: 50, fontWeight: FontWeight.bold)),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, color: BlaColors.primary, size: 40),
                        onPressed: () {
                          if (seatCount < 10) {
                            setDialogState(() {
                              seatCount++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        requestedSeats = seatCount;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlaInput(labelText: departure?.name ?? 'From', iconForm: Icons.circle_outlined, onTap: () => _openFullScreenDialog(context, (location) { setState(() { departure = location; }); }), iconSwitching: Icons.swap_vert, onPressed: _swapLocations),
          BlaInput(labelText: arrival?.name ?? 'Going to', iconForm: Icons.circle_outlined, onTap: () => _openFullScreenDialog(context, (location) { setState(() { arrival = location; }); })),
          BlaInput(labelText: 'Departure date', iconForm: Icons.date_range_sharp, onTap: () => print('you tapped')),
          BlaInput(labelText: '$requestedSeats', iconForm: Icons.person, onTap: () => _showNumberSpinnerDialog(context)),
          BlaButton(text: 'Search', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(departure: departure, arrival: arrival, seatCount: requestedSeats)))),
        ],
      ),
    );
  }
}
