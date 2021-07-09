import 'dart:convert';
import 'package:http/http.dart' as http;

AddUser addUser = new AddUser();

class AddUser{


  Future<http.Response> addNewUser( Map<String , String> formValues) async {
    print("AddOrUpdatePersonPost api called");
    final response = await http.post(
      Uri.parse("https://shoeboxtx.veloxe.com:36251/api/AddOrUpdatePersonPost"),
      headers: <String, String>{
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: jsonEncode(formValues),
    );
    if (response.statusCode == 200) {
      print('AddOrUpdatePersonPost : Success');
    } else {
      print('AddOrUpdatePersonPost : Error');
      print(response.statusCode);
    }
  }
}