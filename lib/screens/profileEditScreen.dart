import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/api_calls/add_user.dart';
import 'package:skywa/api_responses/get_person.dart';
import 'package:skywa/services/locationServices.dart';
import 'package:skywa/api_calls/find_users.dart';
import 'package:skywa/model/person.dart';
import 'package:uuid/uuid.dart';
import 'package:date_format/date_format.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

var uuid = Uuid();
String fullName = "", email = "", address = "", gender = "";
DateTime dob;
///////////////////Date time conversion////////////////////////////
String convertStringFromDate(DateTime dob) {
  String dobStr = formatDate(dob, [mm, '/', dd, '/', yyyy]);
  print(dobStr);
  return dobStr;
}

DateTime convertDateFromString(String strDate) {
  if (strDate != null) {
    DateTime dob = DateTime.parse(strDate);
    return dob;
  } else {
    return DateTime.now();
  }
}

Future<void> callApis(
    BuildContext context, Map<String, String> formValues) async {
  await addUser.addNewUser(formValues);
  await findUsers.returnPerson(context);
}

class ProfileEditPage extends StatefulWidget {
  static const String id = 'profileEditScreen';

  const ProfileEditPage({Key key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  void getLocation() async {
    Location l = new Location();
    await l.getCurrentLocation();
    _formKey.currentState.patchValue({"Address": l.location});
  }

  final _formKey = GlobalKey<FormBuilderState>();
  final nameHolder =
      TextEditingController(text: getPerson.fetchedVal['fullName']);
  final emailHolder =
      TextEditingController(text: getPerson.fetchedVal['email']);
  final addressHolder =
      TextEditingController(text: getPerson.fetchedVal['address']);
  final phoneNumberHolder =
  TextEditingController(text: getPerson.fetchedVal['phoneNumber']);

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Icon(
          //   Icons.more_vert_outlined,
          //   size: 25,
          // )
        ],
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.lato(fontSize: 21),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FormBuilder(
          key: _formKey,
          initialValue: {},
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _image == null
                        ? Image.network(
                            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                            width: 75,
                            height: 75,
                            fit: BoxFit.fill,
                          )
                        : Image.file(
                            _image,
                            width: 75,
                            height: 75,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                style: GoogleFonts.lato(fontSize: 19),
                name: 'Name',
                controller: nameHolder,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context,
                      errorText: 'This field cannot be empty'),
                  FormBuilderValidators.max(context, 70),
                  (val) {}
                ]),
              ),
              SizedBox(
                height: 18,
              ),
              FormBuilderTextField(
                style: GoogleFonts.lato(fontSize: 19),
                name: 'Email',
                controller: emailHolder,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.email(context),
                ]),
              ),
              SizedBox(
                height: 18,
              ),
              FormBuilderDateTimePicker(
                initialTime: TimeOfDay(hour: 8, minute: 0),
                inputType: InputType.date,
                initialValue: getPerson.fetchedVal['dob'] == null
                    ? getPerson.fetchedVal['dob']
                    : convertDateFromString(getPerson.fetchedVal['dob']),
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                name: "DateOfBirth",
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderChoiceChip(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                name: 'Gender',
                spacing: 20.0,
                alignment: WrapAlignment.center,
                initialValue: getPerson.fetchedVal['gender'],
                onChanged: (String value) {},
                options: ['Male', 'Female', 'Others']
                    .map((lang) => FormBuilderFieldOption(
                          value: lang,
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                lang,
                                style: GoogleFonts.lato(),
                              )),
                        ))
                    .toList(growable: false),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                style: GoogleFonts.lato(fontSize: 19),
                name: 'Address',
                controller: addressHolder,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.max(context, 70), (val) {}]),
              ),

              TextButton(
                  onPressed: () {
                    getLocation();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Locate Me",
                        style: GoogleFonts.lato(fontSize: 17 , fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              // FormBuilderFilePicker(
              //   name: "insurance card",
              //   decoration: InputDecoration(border: InputBorder.none ),
              //   maxFiles: null,
              //   previewImages: true,
              //   onChanged: (val) => print(val),
              //   selector: Column(
              //     children: [
              //       SizedBox(
              //         height: 10.0,
              //       ),
              //       Row(
              //         children: <Widget>[
              //           Icon(Icons.attach_file , color:  Theme.of(context).primaryColor,),
              //           Text('Upload Identity/Insurance Card' , style: GoogleFonts.lato(fontSize: 17 ),),
              //         ],
              //       ),
              //     ],
              //   ),
              //   onFileLoading: (val) {
              //     print(val);
              //   },
              // ),
              SizedBox(
                height: 12.0,
              ),
              FormBuilderTextField(
                style: GoogleFonts.lato(fontSize: 19),
                name: 'Phone Number',
                controller: phoneNumberHolder,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.minLength(context, 10,
                        errorText: 'Enter a valid Phone Number'),
                    FormBuilderValidators.maxLength(context, 10,
                        errorText: 'Enter a valid Phone Number'),
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ))),
                      onPressed: () {
                        onSavePressed(_formKey, context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Save",
                          style: GoogleFonts.lato(fontSize: 18),
                        ),
                      )),
                  TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                          color: Theme.of(context).primaryColor
                        )),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ))),
                      onPressed: () {
                        _formKey.currentState.reset();
                        nameHolder.clear();
                        emailHolder.clear();
                        addressHolder.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 10.0),
                        child: Text(
                          "Clear",
                          style: GoogleFonts.lato(fontSize: 18 , color: Theme.of(context).primaryColor),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void onSavePressed(_formKey, BuildContext context) {
  _formKey.currentState.save();
  if (_formKey.currentState.validate()) {
    print(_formKey.currentState.value);
    Map<String, String> formValues = new Map();
    String PersonID;
    if (getPerson.isPersonRegistered) {
      PersonID = getPerson.person.PersonID;
    } else {
      PersonID = uuid.v4();
    }
    //print(PersonID);
    if (_formKey.currentState.value.containsKey('Phone Number') &&
        _formKey.currentState.value['Phone Number'] != null) {
      String countryCode = DB.box.get(DB.countryCallingCode);
      formValues['PersonPhoneNumber'] = "+" + countryCode + " " +
          _formKey.currentState.value['Phone Number'];
    }
    formValues['PersonID'] = PersonID;
    formValues['PersonType'] = 'Self';
    formValues['RecordOwnerDeviceID'] = userSettings.deviceID.value;
    formValues['DeviceID'] = userSettings.deviceID.value;
    if (_formKey.currentState.value["Name"] != null) {
      List<String> fullName = _formKey.currentState.value["Name"].split(' ');
      print(fullName.length);
      if (fullName.length == 3) {
        if (fullName[0] != '') {
          formValues['FirstName'] = fullName[0];
        } else {
          formValues['FirstName'] = "notSet";
        }
        if (fullName[1] != '') {
          formValues['MiddleName'] = fullName[1];
        } else {
          formValues['MiddleName'] = "notSet";
        }
        if (fullName[2] != '') {
          formValues['LastName'] = fullName[2];
        } else {
          formValues['LastName'] = "notSet";
        }
      } else if (fullName.length == 2) {
        if (fullName[0] != '') {
          formValues['FirstName'] = fullName[0];
        } else {
          formValues['FirstName'] = "notSet";
        }
        if (fullName[1] != '') {
          formValues['LastName'] = fullName[1];
        } else {
          formValues['LastName'] = "notSet";
        }
        formValues['MiddleName'] = "notSet";
      } else {
        if (fullName[0] != '') {
          formValues['FirstName'] = fullName[0];
        } else {
          formValues['FirstName'] = "notSet";
        }
        formValues['MiddleName'] = "notSet";
        formValues['LastName'] = "notSet";
      }
    }
    if (_formKey.currentState.value["Gender"] != null) {
      formValues['Sex'] = _formKey.currentState.value["Gender"];
    } else {
      formValues['Sex'] = "notSet";
    }
    if (_formKey.currentState.value["Address"] != null) {
      formValues['Address'] = _formKey.currentState.value["Address"];
    } else {
      formValues['Address'] = "notSet";
    }
    if (_formKey.currentState.value["Email"] != null) {
      formValues['PersonEmail'] = _formKey.currentState.value["Email"];
    } else {
      formValues['PersonEmail'] = "notSet";
    }
    if (_formKey.currentState.value["DateOfBirth"] != null) {
      formValues['Birthday'] =
          _formKey.currentState.value["DateOfBirth"].toString();
    } else {
      formValues['Birthday'] = "notSet";
    }

///////////////////////////// again call the two apis for adding and updating/////////////////////////////////////
    callApis(context, formValues);
  }
}
