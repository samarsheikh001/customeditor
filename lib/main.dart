import 'package:customeditor/custom_editor/custom_text_controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CustomTextController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomTextController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _controller,
              ),
              TextButton(
                onPressed: () {
                  _controller.setSelectedBold();
                },
                child: Text('Set Bold'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
