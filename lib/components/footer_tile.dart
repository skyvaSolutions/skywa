import 'package:flutter/material.dart';

class FooterTile extends StatefulWidget {
  final Function() onPressed;
  final icon;
  final text;
  const FooterTile({Key key , @required this.onPressed , @required this.icon , @required this.text}) : super(key: key);

  @override
  _FooterTileState createState() => _FooterTileState();
}

class _FooterTileState extends State<FooterTile> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
            )
          )
        ),

      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              child: Icon(widget.icon , color :  Theme.of(context).primaryColor),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios , color: Theme.of(context).primaryColor,)
          ],

        ),
      ),
    );
  }
}
