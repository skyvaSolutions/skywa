import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:url_launcher/url_launcher.dart';

Column helpTile(BuildContext context, String title, String contents) {
  return Column(
    children: [
      MenuListTile(
        icon: Icons.help_outline,
        title: title,
//      icon: Icons.info_outline_rounded,
        onTap: () => {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              //  backgroundColor: Colors.grey.shade200,
              title: Text(
                title,
                // style: TextStyle(color: Colors.white),
              ),
              content: Text(
                contents,
                //  style: TextStyle(color: Colors.black)
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"),
                  //,
                ),
              ],
            ),
          )
        },
      ),
      Divider(
        height: 1,
        thickness: 1,
      )
    ],
  );
}

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

Column helpTileURL(BuildContext context, String title, String contents,
    String label, String URL) {
  return Column(
    children: [
      MenuListTile(
        title: title,
//      icon: Icons.info_outline_rounded,
        onTap: () => {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              //  backgroundColor: Colors.grey.shade200,
              title: Text(
                title,
                // style: TextStyle(color: Colors.white),
              ),
              content: Text(
                contents,
                //  style: TextStyle(color: Colors.black)
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    launchURL(URL);
                  },
                  child: Text(label),
                  //,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("okay"),
                  //,
                ),
              ],
            ),
          )
        },
      ),
      Divider(
        height: 10,
        thickness: 5,
      )
    ],
  );
}

class MenuListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const MenuListTile({Key key, this.title, this.onTap, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xFF4C44B3),
        //   size: kIconSettingSize,
        //  color: Colors.white,
      ),
      title: Text(
        title,
        // style: TextStyle(color: Colors.white),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        // size: kIconSettingSize,
        color: Colors.transparent,
      ),
      onTap: onTap,
    );
  }
}

class MenuListTileWithSwitch extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool value;
  final IconData icon;

  const MenuListTileWithSwitch({
    Key key,
    this.title,
    this.onTap,
    this.value,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        //   size: kIconSettingSize,
        color: Color(0xFF4C44B3),
      ),
      title: Text(
        title,
        //  style: TextStyle(color: Colors.white)
      ),
      trailing: Container(
        height: 24,
        width: 48,
        child: CupertinoSwitch(
          activeColor: Color(0xFF4C44B3),
          value: value ?? false,
          onChanged: (_) {
            onTap();
          },
        ),
      ),
      onTap: onTap,
    );
  }
}

Future showAlert(BuildContext context, String title, String body) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text("okay"),
        ),
      ],
    ),
  );
}

//AlertDialog buildAlertDialog(
//    BuildContext context, String title, String content) {
//  return AlertDialog(
//    backgroundColor: Colors.white,
//    title: Text(title,
//        style: TextStyle(
//          color: Colors.yellow,
//        )),
//    content: Text(content,
//        style: TextStyle(
//          color: Colors.yellow,
//        )),
//    actions: <Widget>[
//      TextButton(
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          child: Text('Done'))
//    ],
//  );
//}
Widget createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon , color : Colors.white),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text , style: TextStyle(color: Colors.white),),
        )
      ],
    ),
    onTap: onTap,
  );
}

Widget createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.all(20.0),
      //decoration:
      // BoxDecoration(
      //     image: DecorationImage(
      //          image: AssetImage('assets/images/wait1.png'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
      ClipRRect(
      borderRadius: BorderRadius.circular(50),
            child : Image.asset(
              'assets/images/icon white background.png',
              width: 75,
              height: 75,
              fit: BoxFit.fill,
            )),
        SizedBox(
          height: 20.0,
        ),
        Text('Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w500)),
      ]
      ));
}
