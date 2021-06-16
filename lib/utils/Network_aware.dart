import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywa/screens/Error.page.dart';
import 'package:skywa/services/deviceConnection.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({Key key, this.onlineChild, this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
    if (networkStatus == NetworkStatus.Online) {
      return onlineChild;
    } else {
      return ErrorPage();
    }
  }

  
}