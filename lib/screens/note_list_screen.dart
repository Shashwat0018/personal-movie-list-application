import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter1_app/helper/note_provider.dart';
import 'package:flutter1_app/widgets/list_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter1_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatelessWidget{
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<NoteProvider>(context,listen: false).getNotes(),
      builder: (context,snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else
        {
          if(snapshot.connectionState == ConnectionState.done)
          {
            return Scaffold(
              body: Consumer<NoteProvider>(
                child: noNotesUI(context),
                builder: (context, noteprovider, child) =>
                noteprovider.items.length <= 0 ? child! :
                ListView.builder(
                  itemCount: noteprovider.items.length + 1,
                  itemBuilder: (context, index)
                  {
                    if (index == 0)
                    {
                      return header();
                    }
                    else
                    {
                      final i = index - 1;
                      final item = noteprovider.items[i];
                      return ListItem(
                        id: item.id,
                        title: item.title,
                        content: item.content,
                        imagePath: item.imagePath,
                        date: item.date,
                      );
                    }
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  goToNoteEditScreen(context);
                },
                child: Icon(Icons.add),
              ),
            );
          }
          return Container(
            width: 0.0,
            height: 0.0,
          );
        }

      },
    );
  }
  Widget header() {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        decoration: BoxDecoration(
          color: headerColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(75.0),
          ),
        ),
        height: 150,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MOVIES\'S',
              style: headerRideStyle,
            ),
            Text(
              'LIST',
              style: headerNotesStyle,
            ),
          ],
        ),
      ),
    );
  }
  _launchUrl() async {
    const url = 'https://www.movieslist.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget noNotesUI(BuildContext context) {
    return ListView(
      children: [
        header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'emptymovie.png',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
            RichText(
              text: TextSpan(
                style: noNotesStyle,
                children: [
                  TextSpan(text: ' There is no movie available\nTap on "'),
                  TextSpan(
                      text: '+',
                      style: boldPlus,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          goToNoteEditScreen(context);
                        }),
                  TextSpan(text: '" to add new movie'),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
  void goToNoteEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NoteEditScreen.route);
  }
}
