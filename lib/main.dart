import 'package:customeditor/custom_editor/markdown_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
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

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MarkDownProvider(2),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Consumer<MarkDownProvider>(
                    builder: (context, state, child) {
                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                  children: state.markDownEditors
                                      .elementAt(index)
                                      .editorWidgets),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          state.markDownEditors.first.addImage();
                        },
                        child: const Text('Test'),
                      )
                    ],
                  );
                }),
              ),
            ),
          );
        });
  }
}
