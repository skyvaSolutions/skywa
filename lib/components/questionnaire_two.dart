import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/components/questionnaire_one.dart';

final _formKey = GlobalKey<FormBuilderState>();

class QuestionnaireTwo extends StatefulWidget {
  final pageNum;
  const QuestionnaireTwo({Key key , this.pageNum}) : super(key: key);

  @override
  _QuestionnaireTwoState createState() => _QuestionnaireTwoState();
}

class _QuestionnaireTwoState extends State<QuestionnaireTwo> {
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
              'Coronavirus Information',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Do you have any of the flu-like symptoms(Fever, Cough, Breathlessness, Loss of Smell or Taste?',
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
              )
              ).toList(growable: false),
              name: 'CovidQuestion1',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: 'This field cannot be empty'),
              ]),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Have you been in contact with people being infected, suspected or diagnosed with COVID-19?',
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
              )
              ).toList(growable: false),
              name: 'CovidQuestion2',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: 'This field cannot be empty'),
              ]),
            ),SizedBox(
              height: 15.0,
            ),
            Text(
              'In the past 14 days have you been tested positive for Covid-19?',
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
              )
              ).toList(growable: false),
              name: 'CovidQuestion3',
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
                  onPressed: (){
                    Navigator.pushNamed(context, 'Question3');
                  },
                  child: Text('Next'),
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
