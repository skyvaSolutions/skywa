import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skywa/services/locationServices.dart';

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
          Icon(
            Icons.more_vert_outlined,
            size: 25,
          )
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
                initialValue: "John Doe",
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
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                name: "Date",
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderRadioGroup(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                name: 'Gender',
                options: ['MALE', 'FEMALE']
                    .map((lang) => FormBuilderFieldOption(
                          value: lang,
                          child: Container(
                              padding: EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * 0.3,
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
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.max(context, 70), (val) {}]),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    getLocation();
                  },
                  child: Text(
                    "Get Location",
                    style: GoogleFonts.lato(fontSize: 14),
                  )),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(
                              top: 10, left: 25, right: 25, bottom: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        _formKey.currentState.save();
                        if (_formKey.currentState.validate()) {
                          print(_formKey.currentState.value);
                          print(_formKey.currentState.value["Name"]);
                        }
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.lato(fontSize: 18),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(
                            top: 10, left: 25, right: 25, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _formKey.currentState.reset();
                      },
                      child: Text(
                        "Clear",
                        style: GoogleFonts.lato(fontSize: 18),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
