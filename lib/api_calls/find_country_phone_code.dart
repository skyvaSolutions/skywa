import 'dart:convert';
import 'package:http/http.dart' as http;

CountryCallingCode countryCallingCode = new CountryCallingCode();
class CountryCallingCode{

  Map<String , dynamic> countryCallingCodeMap = {};

  Future<void> findCountryCallingCode() async {
    print("countryCodeWithCallingCode api called");
    String url = "http://country.io/phone.json";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      countryCallingCodeMap = json.decode(response.body);
    }
    else {
      print("countryCodeWithCallingCode api error");

    }
  }

}
