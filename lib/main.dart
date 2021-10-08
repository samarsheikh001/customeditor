import 'package:decks_app/colors.dart';
import 'package:decks_app/custom_circle.dart';
import 'package:decks_app/deck_card.dart';
import 'package:decks_app/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'extensions.dart';
import 'markdown-editor/markdown_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MarkdownProvider())
      ],
      builder: (context, child) => MaterialApp(
        title: 'Decks App',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: CreateNewDeck(),
      ),
    );
  }
}

class CreateNewDeck extends StatefulWidget {
  const CreateNewDeck({Key? key}) : super(key: key);

  @override
  _CreateNewDeckState createState() => _CreateNewDeckState();
}

class _CreateNewDeckState extends State<CreateNewDeck> {
  bool deckEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Create New Desk',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20.0),
                ),
              ),
              child: _buildCreateDeckWidget(context),
            ),
          ),
          Expanded(
            child: _buildDecksList(context).addPad(16.0),
          ),
        ],
      ),
    );
  }

  bool _switchValue = false;

  Widget _buildCreateDeckWidget(context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: secondaryColor, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: secondaryColor, width: 1.0),
              ),
              hintText: 'Enter Your Deck Title',
              hintStyle: textTheme.headline6!.copyWith(color: secondaryColor)),
        ),
        SizedBox(
          height: 18.0,
        ),
        Text(
          'Stay organized by tagging this deck',
          style: textTheme.button,
        ),
        ActionChip(
          label: Text(
            'Add Tags',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
          onPressed: () {},
        ),
        Divider(
          thickness: 1.0,
        ).addVerticalPad(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visible to everyone',
                    style: textTheme.button,
                  ),
                  Text(
                    'Other student can find view and study this deck',
                    style: GoogleFonts.poppins(color: textGrey, fontSize: 12.0),
                  ).addVerticalPad()
                ],
              ),
            ),
            SizedBox(width: 42.0),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: switchColor,
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            )
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor.withOpacity(0.6)),
            ),
            onPressed: null,
            child: Text(
              'Create',
              style: textTheme.button!
                  .copyWith(color: Colors.white, fontSize: 16.0),
            ).addVerticalPad(14.0),
          ),
        ).addVerticalPad(16.0)
      ],
    );
  }

  Widget _buildDecksList(context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Decks created by you',
          style: textTheme.button!.copyWith(fontSize: 16.0),
        ).addVerticalPad(),
        Expanded(
          child: deckEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/decks_ico.png'),
                    Text(
                      'Your Decks will be appeared here once you create them',
                      style: TextStyle(color: Colors.black38),
                      textAlign: TextAlign.center,
                    ).addPad(24.0).addHorizontalPad(14.0)
                  ],
                )
              : ListView(
                  children: [
                    DeckCard(
                      ringColor: Color(0xffF7986A),
                    ),
                    DeckCard(
                      ringColor: Color(0xff37BFE6),
                    ),
                    DeckCard(
                      ringColor: Color(0xffAAB6F9),
                    )
                  ],
                ),
        ),
      ],
    );
  }
}
