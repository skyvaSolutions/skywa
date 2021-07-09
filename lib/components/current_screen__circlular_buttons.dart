import 'package:flutter/material.dart';

class CircularIconButtons extends StatefulWidget {
  final Color bg;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  const CircularIconButtons({Key key, this.bg,this.icon,this.text , this.onPressed}) : super(key: key);

  @override
  _CircularIconButtonsState createState() => _CircularIconButtonsState();
}

class _CircularIconButtonsState extends State<CircularIconButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.bg == Colors.redAccent ? Colors.red.withOpacity(0.4) : Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: Offset(3, 3),
              ),
            ],
            color: widget.bg,
          ),
          width: 60.0,
          height: 60.0,
          child: Center(
            child: IconButton(
              icon: Icon(widget.icon),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: widget.onPressed,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: 100.0,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.bg,
            ),
          ),
        ),
      ],
    );
  }
}
