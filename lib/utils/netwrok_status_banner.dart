import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:smavio/constant.dart';

class NetworkBanner extends StatefulWidget {
  final bool isPopup;
  const NetworkBanner({
    Key? key,
    this.isPopup = false,
  }) : super(key: key);

  @override
  State<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends State<NetworkBanner> {
  StreamSubscription? internetconnection;
  
  StreamSubscription? connection;

  bool isoffline = false;

  @override
  void initState() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<ConnectionStatus>(context,listen: false);
    return isoffline == true
        ?showCustomAlertBox(context: context, title: 'title', body: 'body')
        : SizedBox();
  }
}
