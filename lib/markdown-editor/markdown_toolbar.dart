import 'package:decks_app/colors.dart';
import 'package:decks_app/icons.dart';
import 'package:decks_app/markdown-editor/custom_text_controller.dart';
import 'package:decks_app/markdown-editor/markdown_provider.dart';
import 'package:decks_app/paint_screen/paint_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MarkdownToolbar extends StatefulWidget {
  const MarkdownToolbar({Key? key, this.pageController, required this.callback})
      : super(key: key);
  final PageController? pageController;
  final Function callback;

  @override
  _MarkdownToolbarState createState() => _MarkdownToolbarState();
}

class _MarkdownToolbarState extends State<MarkdownToolbar>
    with WidgetsBindingObserver {
  bool _keyboardVisible = false;
  bool _imageSourceSelected = false;

  void _toggleImageSource() {
    setState(() {
      _imageSourceSelected = !_imageSourceSelected;
      widget.callback(_imageSourceSelected);
    });
  }

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
    return Consumer<MarkdownProvider>(builder: (context, state, __) {
      return _keyboardVisible
          ? Column(
              children: [
                _imageSourceSelected
                    ? _buildImageSourceWidget(context)
                    : Container(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xffE0E0E0),
                      ),
                    ),
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
                                page: widget.pageController!.page!.toInt(),
                              ),
                            ),
                          );
                        },
                        icon: SvgPicture.asset('icons/paint.svg'),
                      ),
                      IconButton(
                        onPressed: () => state.markDownEditors
                            .elementAt(widget.pageController!.page!.toInt())
                            .setStyle(Markdown.bold),
                        icon: SvgPicture.asset('icons/B.svg'),
                      ),
                      IconButton(
                        onPressed: () => state.markDownEditors
                            .elementAt(widget.pageController!.page!.toInt())
                            .setStyle(Markdown.italic),
                        icon: SvgPicture.asset('icons/I.svg'),
                      ),
                      IconButton(
                        onPressed: () => state.markDownEditors
                            .elementAt(widget.pageController!.page!.toInt())
                            .setStyle(Markdown.underline),
                        icon: SvgPicture.asset('icons/U.svg'),
                      ),
                      IconButton(
                        onPressed: state.markDownEditors
                            .elementAt(widget.pageController!.page!.toInt())
                            .addBullet,
                        icon: SvgPicture.asset('icons/paragraph.svg'),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 32,
                          width: 32,
                          color: _imageSourceSelected
                              ? primaryColor
                              : Colors.white,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            color: _imageSourceSelected
                                ? secondaryColor
                                : Colors.black,
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
                  ), // this widget goes to the builder's child property. Made for better performance.
                ),
              ],
            )
          : Container();
    });
  }

  _buildImageSourceWidget(context) {
    return Consumer<MarkdownProvider>(builder: (context, state, __) {
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
                      .elementAt(widget.pageController!.page!.toInt())
                      .addImage(ImageSource.gallery);
                },
                icon: CircleAvatar(
                  backgroundColor: Color(0xffAAB6F9),
                  child: SvgPicture.asset(
                    'icons/gallery.svg',
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  'Image',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  state.markDownEditors
                      .elementAt(widget.pageController!.page!.toInt())
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
    });
  }
}
