import 'package:week_3_blabla_project/service/rides_service.dart';

void main(){
 final today=DateTime.now(); 
 for (var availaberides in RidesService.availableRides){
  if(availaberides.departureDate.month==today.month&&availaberides.departureDate.day==today.day){
    print(availaberides);
  }
 };
}