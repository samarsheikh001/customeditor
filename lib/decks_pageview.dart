import 'dart:math' as Math;

import 'package:decks_app/colors.dart';
import 'package:decks_app/icons.dart';
import 'package:decks_app/markdown-editor/editor_expanded.dart';
import 'package:decks_app/markdown-editor/markdown_editor.dart';
import 'package:decks_app/markdown-editor/markdown_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'extensions.dart';
import 'markdown-editor/markdown_toolbar.dart';

class DecksPageView extends StatefulWidget {
  const DecksPageView({Key? key}) : super(key: key);

  @override
  _DecksPageViewState createState() => _DecksPageViewState();
}

class _DecksPageViewState extends State<DecksPageView>
    with WidgetsBindingObserver {
  bool _keyboardVisible = false;
  bool _imageSourceSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final _bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newVal = _bottomInset > 0.0;
    if (newVal != _keyboardVisible)
      setState(() {
        _keyboardVisible = newVal;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: _buildAppBar(),
      body: _PageViewWidget(
        callBack: (value) {
          setState(() {
            _imageSourceSelected = value;
          });
        },
      ),
      floatingActionButton:
          Consumer<MarkdownProvider>(builder: (context, state, child) {
        return Container(
          margin: EdgeInsets.only(
              bottom: _keyboardVisible
                  ? 36.0 + (_imageSourceSelected ? 55 : 0)
                  : 0),
          child: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: state.addEditor,
            child: Icon(Icons.add_rounded),
          ),
        );
      }),
    );
  }

  _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: Navigator.of(context).pop,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset('icons/cross.svg',color: primaryColor,),
        ),
      ).addHorizontalPad(),
      actions: [
        Consumer<MarkdownProvider>(builder: (context, state, child) {
          return WillPopScope(
            onWillPop: () async {
              for (MarkdownEditor _markdownEditor in state.markDownEditors)
                  await _markdownEditor.saveFile();
                state.setFileLength();
                Navigator.of(context).pop();
              return true;
            },
            child: GestureDetector(
              onTap: () async {
                for (MarkdownEditor _markdownEditor in state.markDownEditors)
                  await _markdownEditor.saveFile();
                state.setFileLength();
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child:SvgPicture.asset('icons/arrow-right.svg',color: primaryColor,),
              ).addPad(),
            ),
          );
        })
      ],
      backgroundColor: primaryColor,
    );
  }
}

class _PageViewWidget extends StatefulWidget {
  const _PageViewWidget({Key? key, required this.callBack}) : super(key: key);
  final Function callBack;

  @override
  __PageViewWidgetState createState() => __PageViewWidgetState();
}

class __PageViewWidgetState extends State<_PageViewWidget> {
  late PageController _pageController;
  double? pageOffset = 0;
  double viewportFraction = 0.9;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: viewportFraction)
      ..addListener(() {
        setState(
          () {
            pageOffset = _pageController.page;
          },
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: Provider.of<MarkdownProvider>(context).length,
              itemBuilder: (context, index) {
                double scale = Math.max(viewportFraction,
                    (1 - (pageOffset! - index).abs()) + viewportFraction);

                return Padding(
                  padding: EdgeInsets.only(
                    top: 60 - scale * 25,
                    bottom: 10.0,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0XFFF7986A)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 200,
                    child: _buildPage(index),
                  ),
                );
              }),
        ),
        MarkdownToolbar(
          pageController: _pageController,
          callback: widget.callBack,
        )
      ],
    );
  }

  Widget _buildPage(index) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildSelectSubject()),
            Expanded(child: _buildSelectSubject()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CustomPaint(
            painter: _DashedLinePainter(),
            child: Container(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: TextField(
            style: textTheme.headline6,
            maxLines: null,
            decoration: InputDecoration.collapsed(
              hintText: 'Question',
              hintStyle: TextStyle(
                color: Color(0xffE0E0E0),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ).addVerticalPad(),
        Expanded(
          child: Consumer<MarkdownProvider>(builder: (context, state, child) {
            return GestureDetector(
              onTap: state.markDownEditors
                  .elementAt(index)
                  .nodes
                  .last
                  .requestFocus,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      state.markDownEditors.elementAt(index).editorWidgets,
                ).addHorizontalPad(),
              ),
            );
          }),
        ),
        Consumer<MarkdownProvider>(builder: (context, state, child) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  state.removeEditorAt(index);
                },
                child: SvgPicture.asset('icons/delete.svg')
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpandedEditor(
                        page: _pageController.page!.toInt(),
                        key: UniqueKey(),
                      ),
                    ),
                  );
                },
                child: SvgPicture.asset('icons/expand.svg').addHorizontalPad(16),
              ),
            ],
          ).addPad(16.0);
        })
      ],
    );
  }

  Container _buildSelectSubject() {
    final textTheme = Theme.of(context).textTheme;
    String dropdownValue = 'Select Subject';
    return Container(
      constraints: BoxConstraints(maxHeight: 36),
      margin: EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
          color: Color(0xffF8F8F8), borderRadius: BorderRadius.circular(4.0)),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: SvgPicture.asset(
            'icons/chevron-down.svg',
            alignment: Alignment.bottomRight,
            color: Color(0xff828282),
          ),
        ),
        iconSize: 24,
        elevation: 16,
        style: textTheme.button,
        underline: const SizedBox(),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>[
          'Select Subject',
          'Option Two',
          'Option Tree',
          'Option Four'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Color(0xff828282)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Color(0xffE0E0E0)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
