import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/components/questionnaire_one.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/screens/homeScreen.dart';
import 'package:skywa/screens/questionairre_screen.dart';

final _formKey = GlobalKey<FormBuilderState>();

class QuestionnaireThree extends StatefulWidget {
  final pageNum;
  const QuestionnaireThree({Key key, this.pageNum}) : super(key: key);

  @override
  _QuestionnaireThreeState createState() => _QuestionnaireThreeState();
}

class _QuestionnaireThreeState extends State<QuestionnaireThree> {
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
              'Declaration',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Would you like the business to keep a record of your data for further appointments?',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            FormBuilderRadioGroup(
              decoration: InputDecoration(border: InputBorder.none),
              activeColor: Theme.of(context).primaryColor,
              wrapAlignment: WrapAlignment.spaceAround,
              options: ['Yes', 'No']
                  .map((lang) => FormBuilderFieldOption(
                        value: lang,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            lang,
                            style: GoogleFonts.lato(),
                          ),
                        ),
                      ))
                  .toList(growable: false),
              name: 'Declaration1',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: 'This field cannot be empty'),
              ]),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Would you like to be kept updated regarding further appointments/Discounts(if any)?',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            FormBuilderRadioGroup(
              decoration: InputDecoration(border: InputBorder.none),
              activeColor: Theme.of(context).primaryColor,
              options: ['Yes', 'No']
                  .map((lang) => FormBuilderFieldOption(
                        value: lang,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            lang,
                            style: GoogleFonts.lato(),
                          ),
                        ),
                      ))
                  .toList(growable: false),
              name: 'Declaration2',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: 'This field cannot be empty'),
              ]),
            ),
            SizedBox(
              height: 15.0,
            ),
            FormBuilderCheckbox(
              decoration: InputDecoration(border: InputBorder.none),
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) {},
              initialValue: false,
              title: Text(
                'I accept the Terms and Conditions of the business',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              name: 'Accept',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: 'This field cannot be empty'),
              ]),
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
                SizedBox(
                  width: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Reset' , style: TextStyle(color: Theme.of(context).primaryColor),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: Theme.of(context).primaryColor)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    goBack();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
