import 'package:flutter/material.dart';
import 'package:smavio/utils/hive_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await HiveDBServices().getLoginData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                child: Text(loginData[0].token),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await HiveDBServices().deleteLogin();
                  },
                  child: const Text('delete'))
            ],
          ),
        ),
      ),
    );
  }
}
