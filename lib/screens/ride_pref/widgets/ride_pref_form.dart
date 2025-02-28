import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/dummy_data/dummy_data.dart';
import 'package:week_3_blabla_project/screens/ride_pref/ride_screen.dart';
import 'package:week_3_blabla_project/theme/theme.dart';
import 'package:week_3_blabla_project/utils/date_time_util.dart';
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
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedSeats = widget.initRidePref!.requestedSeats;
    } else {
      // If no given preferences, we select default ones :
      departure = null; // User shall select the departure
      departureDate = DateTime.now(); // Now  by default
      arrival = null; // User shall select the arrival
      requestedSeats = 1; // 1 seat book by default
    }
  }

  // function to show dialog for location picker
  void _openFullScreenDialog(
      BuildContext context, Function(Location) onLocationSelected) {
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
                  icon:
                      Icon(Icons.arrow_back_ios, color: BlaColors.neutralLight),
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
                        return ListTile(
                          leading: Icon(Icons.location_on,
                              color: BlaColors.neutralLight, size: 20),
                          title: Text(filteredLocations[index].name),
                          subtitle: Text(filteredLocations[index].country.name),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: BlaColors.neutralLight, size: 16),
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

  // function to show number spinner
  void _showNumberSpinnerDialog(BuildContext context) {
    Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(
        StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              backgroundColor: BlaColors.white,
              appBar: AppBar(
                backgroundColor: BlaColors.white,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: BlaColors.neutralLight),
                ),
                title: Text('Select Number of Seats',
                    style: TextStyle(color: BlaColors.neutralDark)),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text("Number of seats to book",
                      style: TextStyle(
                          color: BlaColors.neutralDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: BlaColors.neutralLight, size: 40),
                        onPressed: () {
                          if (requestedSeats > 1) {
                            setDialogState(() {
                              requestedSeats--;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      Text('$requestedSeats',
                          style: TextStyle(
                              color: BlaColors.neutralDark,
                              fontSize: 50,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline,
                            color: BlaColors.primary, size: 40),
                        onPressed: () {
                          if (requestedSeats < 10) {
                            setDialogState(() {
                              requestedSeats++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  BlaButton(
                    text: 'Confirm',
                    onPressed: () {
                      setState(() {
                        requestedSeats;
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // // function return dialog of date picrkre
  Future<DateTime?> _showDatePickerDialog(BuildContext context) async {
    DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime currentDate = DateTime.now();
        DateTime pickedDate = currentDate;

        return AlertDialog(
          title: Text(
            "Select your departure date",
            style: BlaTextStyles.heading,
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalendarDatePicker(
                      initialDate: pickedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      onDateChanged: (date) {
                        setState(() {
                          pickedDate = date;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            BlaButton(
              text: 'Cancel',
              isPrimary: false,
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
            ),
            BlaButton(
              text: 'Confirm',
              onPressed: () {
                Navigator.of(context).pop(pickedDate); // Cancel button
              },
            ),
          ],
        );
      },
    );

    return selectedDate;
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
              onPressed: _swapLocations),
          BlaInput(
              labelText: arrival?.name ?? 'Going to',
              iconForm: Icons.circle_outlined,
              onTap: () => _openFullScreenDialog(context, (location) {
                    setState(() {
                      arrival = location;
                    });
                  })),
          BlaInput(
            labelText: DateTimeUtils.formatDateTime(departureDate),
            iconForm: Icons.date_range_sharp,
            onTap: () async {
              DateTime? selectedDate = await _showDatePickerDialog(context);
              if (selectedDate != null) {
                setState(() {
                  departureDate = selectedDate; // Save new date
                });
              }
            },
          ),
          BlaInput(
              labelText: '$requestedSeats',
              iconForm: Icons.person,
              onTap: () => _showNumberSpinnerDialog(context)),
          BlaButton(
              text: 'Search',
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RideScreen(
                            departure: departure,
                            arrival: arrival,
                            seatCount: requestedSeats,
                            date:
                                '${DateTimeUtils.formatDateTime(departureDate)}',
                          )))),
        ],
      ),
    );
  }
}
