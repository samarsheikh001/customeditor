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

  List list = [1, 2, 3, 4, 5];

  changeList(List _list) {
    _list = [1];
  }

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
                  changeList(list);
                  print(list);
                  _controller.setSelectedWithStyle(Markdown.Italic);
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
