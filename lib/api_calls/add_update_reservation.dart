import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

AddUpdateReservation addUpdateReservation = new AddUpdateReservation();

class AddUpdateReservation{

  Future<http.Response> addUpdateRes( Map<String , dynamic> reservationValues) async {
    print("AddOrUpdateReservation api called");
    final response = await http.post(
      Uri.parse("https://shoeboxtx.veloxe.com:36251/api/AddorUpdateReservationPost"),
      headers: <String, String>{
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: jsonEncode(reservationValues),
    );
    if (response.statusCode == 200) {
      print('AddOrUpdateReservation : Success');
    } else {
      print('AddOrUpdateReservation : Error');
      print(response.statusCode);
    }
  }


}


//Dio dio = new Dio();

// void UpdateRes(reservationValues) async {
//   print(reservationValues);
//   print('Updating...');
//   var response = await dio.post(
//       "https://shoeboxtx.veloxe.com:36251/api/AddorUpdateReservationPost",
//       data: reservationValues);
//   print(response.statusCode);
//   print(response.data);
// }













