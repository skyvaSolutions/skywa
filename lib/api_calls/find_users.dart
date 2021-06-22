import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/api_responses/get_person.dart';
import 'package:skywa/model/person.dart';

FindUsers findUsers = new FindUsers();
class FindUsers{
  Person person;

  Future<Person> findPersonRegistered(BuildContext context) async {
    print("GetMyPeople api called");
    String deviceId = userSettings.deviceID.value;
    String url = "https://shoeboxtx.veloxe.com:36251/api/GetMyPeople?UserToken=$deviceId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('GetMyPeople : Success');
      List<dynamic> res = json.decode(response.body);
      if(res.length >0){
        getPerson.isPersonRegistered = true;
        Map<String , dynamic> resp = res[0];
        print(resp);
        person =  Person.fromJson(resp);
        return person;
      }
      else{
        getPerson.isPersonRegistered = false;
        return null;
      }

    }
    else {
      print('GetMyPeople : Error');
    }
    return null;
  }


  void returnPerson(BuildContext context) async {
    Person person = await FindUsers().findPersonRegistered(context);
    if(getPerson.isPersonRegistered)
      getPerson.person = person;
    getPerson.fetchedVal = initializeVariables();
    print(getPerson.fetchedVal);
  }

  Map<String , String> initializeVariables(){
    Map<String , String> fetchedValues = new Map<String , String>();
    if(getPerson.isPersonRegistered){
      if(getPerson.person.FirstName != "notSet")
        fetchedValues['fullName'] = getPerson.person.FirstName;
      if(getPerson.person.MiddleName != "notSet")
        fetchedValues['fullName'] += " " + getPerson.person.MiddleName;
      if(getPerson.person.LastName != "notSet")
        fetchedValues['fullName'] += " " + getPerson.person.LastName;
      if(getPerson.person.PersonEmail != "notSet")
        fetchedValues['email'] =getPerson.person.PersonEmail;
      if(getPerson.person.Address != "notSet")
        fetchedValues['address'] = getPerson.person.Address;
      if(getPerson.person.Birthday != "notSet")
        fetchedValues['dob'] = getPerson.person.Birthday;
      if(getPerson.person.Sex != "notSet")
        fetchedValues['gender'] = getPerson.person.Sex;
    }
    else{
      fetchedValues['fullName'] = null;
      fetchedValues['email'] = null;
      fetchedValues['address'] = null;
      fetchedValues['dob'] = null;
      fetchedValues['gender'] = null;
    }
    return fetchedValues;
  }


}