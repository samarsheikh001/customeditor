import 'package:decks_app/colors.dart';
import 'package:decks_app/icons.dart';
import 'package:decks_app/markdown-editor/markdown_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'decks_pageview.dart';
import 'extensions.dart';
import 'custom_circle.dart';

class DeckCard extends StatelessWidget {
  final Color? ringColor;
  const DeckCard({Key? key, this.ringColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CustomPaint(
        foregroundPainter: CustomCircle(ringColor!),
        child: Container(
          color: Colors.white,
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anatomy Deck 01',
                    style: GoogleFonts.poppins(fontSize: 22),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'icons/stories.svg',
                        width: 14,
                      ),
                      Text(
                        '30 Cards',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ).addHorizontalPad(4),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'icons/calendar.svg',
                        color: Colors.grey,
                        width: 12,
                      ),
                      Text(
                        '5 July 2020',
                        style:
                            GoogleFonts.poppins(color: textGrey, fontSize: 12),
                      ).addHorizontalPad()
                    ],
                  ).addVerticalPad()
                ],
              ).addHorizontalPad(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: ColoredBox(
                          color: editButtonColor,
                          child: Consumer<MarkdownProvider>(
                            builder: (context, state, child) => IconButton(
                              constraints:
                                  BoxConstraints(minHeight: 36, minWidth: 36),
                              iconSize: 16,
                              onPressed: () {
                                state.setFileKey('editorTest06');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // file key(must be unique) is used to identify the local path of saved editor session used
                                    // later to retrieve saved data
                                    builder: (context) => DecksPageView(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              icon: SvgPicture.asset(
                                'icons/Edit.svg',
                                width: 16,
                                color: editIconColor,
                              ),
                            ),
                          ),
                        ),
                      ).addPad(),
                      ClipOval(
                        child: ColoredBox(
                          color: shareButtonColor,
                          child: IconButton(
                            constraints:
                                BoxConstraints(minHeight: 36, minWidth: 36),
                            iconSize: 16,
                            onPressed: () {},
                            icon: Icon(
                              Icons.share_outlined,
                              color: shareIconColor,
                            ),
                          ),
                        ),
                      ).addPad(),
                    ],
                  )
                ],
              )
            ],
          ).addPad(),
        ),
      ),
    ).addVerticalPad();
  }
}
