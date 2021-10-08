import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:decks_app/markdown-editor/markdown_editor.dart';
import 'package:decks_app/markdown-editor/markdown_provider.dart';
import 'package:decks_app/paint_screen/draw_line.dart';
import 'package:decks_app/paint_screen/painting_storage.dart';
import 'package:decks_app/paint_screen/sketcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({Key? key, required this.paintingKey, required this.page})
      : super(key: key);
  final String paintingKey;
  final int page;

  @override
  _PaintScreenState createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  GlobalKey _globalKey = GlobalKey();
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine line = DrawnLine([], Colors.transparent, 0);
  Color _brushColor = Colors.red;
  double _brushSize = 4.0;
  double _brushOpacity = 0.9;

  List<DrawnLine> _redoDrawLines = [];
  Color? _brushBeforeClear;

  List<Color> _colorOptions = [
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.deepPurple
  ];

  List<double> _sizeOptions = [4, 8, 12, 16, 20];

  StreamController<List<DrawnLine>> linesStreamController =
      StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController =
      StreamController<DrawnLine>.broadcast();

  // void _onPanDown(DragDownDetails details) {
  //   lines = List.from(lines)..add(line);
  //   _redoDrawLines = [];
  //   linesStreamController.add(lines);
  //   print('down');
  // }

  void _onPanEnd(DragEndDetails details) {
    lines = List.from(lines)..add(line);
    _redoDrawLines = [];
    linesStreamController.add(lines);
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);
    line =
        DrawnLine([point], _brushColor.withOpacity(_brushOpacity), _brushSize);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);
    List<Offset> path = [...line.path]..add(point);
    line = DrawnLine(path, _brushColor.withOpacity(_brushOpacity), _brushSize);
    currentLineStreamController.add(line);
  }

  //saving the painting
  Future<void> save(BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      // File imageFile = await PaintingStorage.setImage(
      //     widget.paintingKey +
      //         Provider.of<MarkdownProvider>(context, listen: false)
      //             .markDownEditors
      //             .elementAt(widget.page)
      //             .editorWidgets
      //             .length
      //             .toString(),
      //     image);
      print(Provider.of<MarkdownProvider>(context, listen: false)
          .markDownEditors
          .elementAt(widget.page)
          .editorWidgets
          .length
          .toString());
      // Provider.of<MarkdownProvider>(context, listen: false)
      //     .markDownEditors
      //     .elementAt(widget.page)
      //     .addPainting(imageFile);
      // setState(() {});
      Navigator.of(context).pop();
    } catch (e) {
      throw Error();
    }
  }

  @override
  void dispose() {
    linesStreamController.close();
    currentLineStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildAllPath(context),
                _buildCurrentPath(context),
              ],
            ),
          ),
          _buildToolBar(context),
        ],
      ),
    );
  }

  Widget _buildToolBar(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          color: Color(0xffF8F8F8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 90, minHeight: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_brushBeforeClear != null) {
                          _brushColor = _brushBeforeClear!;
                          _brushBeforeClear = null;
                        }
                        setState(() {
                          _brushOpacity = 0.9;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.pen,
                        color: _brushOpacity == 0.9 ? Color(0xffF7986A) : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // print(_brushBeforeClear);
                        if (_brushBeforeClear != null) {
                          _brushColor = _brushBeforeClear!;
                          _brushBeforeClear = null;
                        }
                        setState(() {
                          _brushOpacity = 0.5;
                        });
                      },
                      icon: Icon(
                        Icons.format_paint,
                        color: _brushOpacity == 0.5 ? Color(0xffF7986A) : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _brushBeforeClear = _brushColor;
                        _brushColor = Colors.white;
                        setState(() {
                          _brushOpacity = 1;
                        });
                      },
                      icon: Icon(
                        Icons.clear_sharp,
                        color: _brushOpacity == 1 ? Color(0xffF7986A) : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (line.path.isEmpty && lines.isNotEmpty) {
                          _redoDrawLines.add(lines.removeLast());
                        } else {
                          _redoDrawLines.add(line);
                          line = DrawnLine([],
                              _brushColor.withOpacity(_brushOpacity),
                              _brushSize);
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.undo,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_redoDrawLines.isNotEmpty)
                          lines = List.from(lines)
                            ..add(_redoDrawLines.removeLast());
                        linesStreamController.add(lines);
                      },
                      icon: Icon(
                        Icons.redo,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xff5B4966),
                  child: IconButton(
                    color: Colors.white,
                    iconSize: 34,
                    padding: EdgeInsets.zero,
                    onPressed: () => save(context),
                    icon: Icon(Icons.done),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _colorOptions
                .map(
                  (color) => InkWell(
                    onTap: () {
                      setState(() {
                        _brushColor = color;
                      });
                    },
                    child: Container(
                      width: _brushColor == color || _brushBeforeClear == color
                          ? 40
                          : 25,
                      height: _brushColor == color || _brushBeforeClear == color
                          ? 40
                          : 25,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _sizeOptions
                .map(
                  (size) => InkWell(
                    onTap: () {
                      setState(() {
                        _brushSize = size;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: size == _brushSize
                              ? Border.all(color: Colors.black)
                              : null,
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAllPath(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        padding: EdgeInsets.all(4.0),
        alignment: Alignment.topLeft,
        child: StreamBuilder<List<DrawnLine>>(
          stream: linesStreamController.stream,
          builder: (context, asyncSnapshot) => CustomPaint(
            painter: Sketcher(lines: lines),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPath(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      // onPanDown: _onPanDown,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(4.0),
          color: Colors.transparent,
          alignment: Alignment.topLeft,
          child: StreamBuilder<DrawnLine>(
              stream: currentLineStreamController.stream,
              builder: (context, snapshot) {
                return CustomPaint(
                  painter: Sketcher(lines: [line]),
                );
              }),
        ),
      ),
    );
  }
}
