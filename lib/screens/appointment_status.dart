import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

const completeColor = Colors.teal;
//Color(0xff5ec792);
//Color(0xff878890);
//Color(0xff878890);
const inProgressColor = Color(0xFFFFA63C);
//Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);
int _processIndex = 1;

class AppointmentStatus extends StatefulWidget {
  @override
  _AppointmentStatusState createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus> {


  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 30.0,
            thickness: 5.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (_, __) =>
              MediaQuery.of(context).size.width / _processes.length,
          oppositeContentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: (index == 0)?Icon(Icons.business,color: getColor(index),size: 30.0,) :Image.asset(
                'assets/images/status${index + 1}.png',
                color: getColor(index),
                width: 30.0,
              ),
            );
          },
          contentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _processes[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: getColor(index),
                ),
              ),
            );
          },
          indicatorBuilder: (_, index) {
            var color;
            var child;
            if (index == _processIndex) {
              color = inProgressColor;
            } else if (index < _processIndex) {
              color = completeColor;
            } else {
              color = todoColor;
            }

            if (index <= _processIndex) {
              return Stack(
                children: [
                  DotIndicator(
                    size: 15.0,
                    color: color,
                    child: child,
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  OutlinedDotIndicator(
                    borderWidth: 4.0,
                    color: color,
                  ),
                ],
              );
            }
          },
          connectorBuilder: (_, index, type) {
            if (index > 0) {
              if (index == _processIndex) {
                final prevColor = getColor(index - 1);
                final color = getColor(index);
                List<Color> gradientColors;
                if (type == ConnectorType.start) {
                  gradientColors = [Color.lerp(prevColor, color, 0.5), color];
                } else {
                  gradientColors = [
                    prevColor,
                    Color.lerp(prevColor, color, 0.5)
                  ];
                }
                return DecoratedLineConnector(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                  ),
                );
              } else {
                return SolidLineConnector(
                  color: getColor(index),
                );
              }
            } else {
              return null;
            }
          },
          itemCount: _processes.length,
        ),
      ),
    );
  }
}

final _processes = [
  'Checked In',
  'Called In',
  'In Facility',
];

final statusMess = [
  'You are checked in for the appointment. please wait near by until called.',
  'We are ready for you please walk to the entrance.',
  'Your appointment is in progress.',
];


class StatusMessage extends StatefulWidget {

  @override
  _StatusMessageState createState() => _StatusMessageState();
}

class _StatusMessageState extends State<StatusMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0),),
            color: Color(0xFFFFA63C),
          ),
          child: Text(
            statusMess[_processIndex],
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          )
      ),
    );
  }
}


