import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/api_responses/get_person.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:timelines/timelines.dart';

final _formKey = GlobalKey<FormBuilderState>();
final nameHolder =
    TextEditingController(text: getPerson.fetchedVal['fullName']);
final emailHolder = TextEditingController(text: getPerson.fetchedVal['email']);
final addressHolder =
    TextEditingController(text: getPerson.fetchedVal['address']);
final phoneNumberHolder =
    TextEditingController(text: getPerson.fetchedVal['phoneNumber']);

class QuestionnaireOne extends StatefulWidget {
  final int pageNum;
  const QuestionnaireOne({Key key, this.pageNum}) : super(key: key);
  @override
  _QuestionnaireOneState createState() => _QuestionnaireOneState();
}

List<Container> returnIndicators(BuildContext context, int index) {
  print(index);
  List<Container> indicators = [];
  for (int i = 0; i < 3; i++) {
    indicators.add(
      new Container(
        margin: EdgeInsets.only(right: 6),
        child: Icon(
          Icons.circle,
          size: 12,
          color: i == index ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
    );
  }
  return indicators;
}

class _QuestionnaireOneState extends State<QuestionnaireOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: returnIndicators(context, widget.pageNum),
              ),
            ),
            Text(
              'Tell us more about your self.',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            FormBuilderTextField(
              style: GoogleFonts.lato(fontSize: 19),
              name: 'Name',
              controller: nameHolder,
              decoration: InputDecoration(
                labelText: 'Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              name: "DateOfBirth",
            ),
            SizedBox(
              height: 20,
            ),
            FormBuilderChoiceChip(
              decoration: InputDecoration(
                labelText: 'Gender',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.max(context, 70), (val) {}]),
            ),
            SizedBox(
              height: 12,
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
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState.reset();
                    nameHolder.clear();
                    emailHolder.clear();
                    addressHolder.clear();
                    phoneNumberHolder.clear();
                  },
                  child: Text('Reset'),
                ),
                SizedBox(
                  width: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    onSavePressed(_formKey, context);
                    Navigator.pushNamed(context, 'Question2');
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
