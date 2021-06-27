import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/ThemeProvider.dart';
import 'package:skywa/components/questionnaire_one.dart';
import 'package:skywa/components/questionnaire_three.dart';
import 'package:skywa/components/questionnaire_two.dart';

class QuestionnairePage extends StatefulWidget {
  final int pageNum ;
  const QuestionnairePage({Key key, this.pageNum}) : super(key: key);
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}
BuildContext ctx ;
void goBack(){
  Navigator.pop(ctx);
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  @override
  Widget build(BuildContext context) {
    ctx = context;
    final _prov = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _prov.DarkMode == true ? ThemeMode.dark : ThemeMode.light,
      theme: FlexColorScheme.light(scheme: FlexScheme.hippieBlue).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.hippieBlue
        //  fontFamily: 'Georgia',
      ).toTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: (){
              goBack();
            },
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
              'Complete Questionnaire',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(

            ),
          ),
        ),
        body: Navigator(
          onGenerateRoute: (settings) {
            Widget page = QuestionnaireOne(pageNum: 0);
            if (settings.name == 'Question2')
              page = QuestionnaireTwo(pageNum: 1);
            if(settings.name == 'Question3')
              page = QuestionnaireThree(pageNum: 2);
            return MaterialPageRoute(builder: (_) => page);
          },
        ),
      ),
    );
  }
}
