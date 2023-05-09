import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:smavio/apicall/api_calls.dart';
import 'package:smavio/constant.dart';
import 'package:smavio/model/compaign_assign_modal.dart';
import 'package:smavio/screens/app_drawer.dart';
import 'package:smavio/screens/app_web_view.dart';
import 'package:smavio/utils/hive_helper.dart';

class ComapignScrn extends StatefulWidget {
  const ComapignScrn({super.key});

  @override
  State<ComapignScrn> createState() => _ComapignScrnState();
}

class _ComapignScrnState extends State<ComapignScrn> {
  bool isLoadingfromApi = false;
  String? url;
  StreamController<CompaignAssignModal>? _streamController;
  checkAssignCompaign() async {
    await HiveDBServices().getLoginData();
    String url = '${ApiCalls.urlHeader}/api/user/getCampaign';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${loginData.last.token}'
        },
        body: jsonEncode(
            {"device_uuid": loginData.last.deviceId, "device_type": "app"}));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      log('json ${json.toString()}');
      compaignAssignModal = CompaignAssignModal.fromJson(json);
      _streamController!.sink.add(compaignAssignModal);
      return compaignAssignModal;
    } else {
      _streamController!.sink.addError(response.statusCode);
    }

    // _streamController=  (await ApiCalls().getAssignCompaign(body: {
    //     "device_uuid": loginData.last.deviceId,
    //     "device_type": "app"
    //   })) as StreamController<CompaignAssignModal>?;
  }

  @override
  void initState() {
    _streamController = StreamController<CompaignAssignModal>();

    super.initState();
  }

  @override
  void dispose() {
    _streamController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Center(
              child: StreamBuilder<CompaignAssignModal>(
            stream: _streamController!.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.success == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppWebView()));
                  });
                } else {
                  showDilog(snapshot.data!.error!, context, ontap: () {
                    Navigator.pop(context);
                  });
                }
              } else if (snapshot.hasError) {
                return showDilog(snapshot.data!.error.toString(), context,
                    ontap: () {
                  Navigator.pop(context);
                });
              }
              return const CircularProgressIndicator();
            },
          )),
          ElevatedButton(
              onPressed: () async {
                await checkAssignCompaign();
              },
              child: const Text('press'))
        ],
      ),
    );
  }
}
