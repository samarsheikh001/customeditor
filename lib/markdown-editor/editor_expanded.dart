import 'package:decks_app/icons.dart';
import 'package:decks_app/markdown-editor/markdown_provider.dart';
import 'package:decks_app/paint_screen/paint_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import 'custom_text_controller.dart';
import 'package:decks_app/extensions.dart';

class ExpandedEditor extends StatefulWidget {
  const ExpandedEditor({Key? key, required this.page}) : super(key: key);

  final int page;

  @override
  _ExpandedEditorState createState() => _ExpandedEditorState();
}

class _ExpandedEditorState extends State<ExpandedEditor> {
  bool _imageSourceSelected = false;

  void _toggleImageSource() {
    setState(() {
      _imageSourceSelected = !_imageSourceSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildSelectSubject()),
                Expanded(child: _buildSelectSubject()),
              ],
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
              child: SingleChildScrollView(
                child: Consumer<MarkdownProvider>(
                    builder: (context, state, child) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.markDownEditors
                          .elementAt(widget.page)
                          .editorWidgets);
                }),
              ).addPad(),
            ),
            Consumer<MarkdownProvider>(builder: (context, state, child) {
              return Row(
                children: [
                  SvgPicture.asset('icons/delete.svg'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Future.delayed(
                          Duration(milliseconds: 300),
                          () => state.markDownEditors
                              .elementAt(widget.page)
                              .openSavedFile());
                    },
                    child:
                        SvgPicture.asset('icons/shrink.svg').addHorizontalPad(),
                  ),
                ],
              ).addPad(16.0);
            }),
            _buildExpandedMarkdownToolbar(context),
          ],
        ),
      ),
      floatingActionButton:
          Consumer<MarkdownProvider>(builder: (context, state, child) {
        return Container(
          margin:
              EdgeInsets.only(bottom: 36.0 + (_imageSourceSelected ? 60 : 0)),
          child: FloatingActionButton(
            elevation: 18,
            backgroundColor: primaryColor,
            onPressed: () {
              state.markDownEditors.elementAt(widget.page).saveFile();
              Navigator.of(context).pop();
            },
            child: Icon(Icons.done),
          ),
        );
      }),
    );
  }

  _buildExpandedMarkdownToolbar(context) {
    return Consumer<MarkdownProvider>(builder: (context, state, child) {
      return WillPopScope(
        key: UniqueKey(),
        onWillPop: () async {
          print('called back');
          Future.delayed(
            Duration(milliseconds: 300),
            () => state.markDownEditors.elementAt(widget.page).openSavedFile(),
          );
          return true;
        },
        child: Column(
          children: [
            _imageSourceSelected
                ? _buildImageSourceWidget(state, context)
                : Container(),
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaintScreen(
                                paintingKey: state.fileKey,
                                page: widget.page.toInt(),
                              ),
                            ),
                          );
                    },
                    icon: SvgPicture.asset('icons/paint.svg'),
                  ),
                  IconButton(
                    onPressed: () => state.markDownEditors
                        .elementAt(widget.page)
                        .setStyle(Markdown.bold),
                    icon: SvgPicture.asset('icons/B.svg'),
                  ),
                  IconButton(
                    onPressed: () => state.markDownEditors
                        .elementAt(widget.page)
                        .setStyle(Markdown.italic),
                    icon: SvgPicture.asset('icons/I.svg'),
                  ),
                  IconButton(
                    onPressed: () => state.markDownEditors
                        .elementAt(widget.page)
                        .setStyle(Markdown.underline),
                    icon: SvgPicture.asset('icons/U.svg'),
                  ),
                  IconButton(
                    onPressed:
                        state.markDownEditors.elementAt(widget.page).addBullet,
                    icon: SvgPicture.asset('icons/paragraph.svg'),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 32,
                      width: 32,
                      color: _imageSourceSelected
                          ? primaryColor
                          : Color(0xfff2f2f2),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: _toggleImageSource,
                        icon: SvgPicture.asset(
                          'icons/Camera.svg',
                          color: _imageSourceSelected
                              ? secondaryColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _buildImageSourceWidget(state, context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                state.markDownEditors
                    .elementAt(widget.page)
                    .addImage(ImageSource.gallery);
              },
              icon: CircleAvatar(
                backgroundColor: Color(0xffAAB6F9),
                child: SvgPicture.asset('icons/gallery.svg'),
              ),
              label: Text(
                'Image',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                state.markDownEditors
                    .elementAt(widget.page)
                    .addImage(ImageSource.camera);
              },
              icon: CircleAvatar(
                backgroundColor: Color(0xffF7986A),
                child: SvgPicture.asset(
                  'icons/Camera.svg',
                  color: Colors.white,
                ),
              ),
              label: Text(
                'Camera',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
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
          padding: const EdgeInsets.only(left: 38),
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
