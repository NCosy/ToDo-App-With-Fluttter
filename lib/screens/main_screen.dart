import 'package:flutter/material.dart';
import 'package:todosapp/database/db_provider.dart';
import 'package:todosapp/models/task_model.dart';
import 'package:todosapp/screens/add_screen.dart';
import 'package:todosapp/screens/read_note_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todosapp/admob_service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  BannerAd _ad;
  bool isLoaded;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(onAdLoaded: (_) {
        setState(() {
          isLoaded = true;
        });
      }, onAdFailedToLoad: (_, error) {
        print("Ad Failed to Load with Error : $error");
      }),
    );

    _ad.load();
  }

  Widget checkForAd() {
    return Container(
      child: AdWidget(
        ad: _ad,
      ),
      width: 470,
      height: 60,
      alignment: Alignment.center,
      //margin: EdgeInsets.only(left: 55),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      // ignore: deprecated_member_use
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xFF555753),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'My Notes',
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: checkForAd(),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 2),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: getPriorityColor(this.noteList[position].priority),
                    width: 1.9),
                borderRadius: BorderRadius.circular(30),
              ),
              color: Color(0xFF2C2B2C),
              elevation: 2.0,
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(left: 2, right: 12, bottom: 10, top: 10),
                leading: Container(
                  margin: EdgeInsets.only(left: 20, right: 5),
                  child: IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xe4ffffff),
                      //size: 35,
                    ),
                    onPressed: () {
                      navigateToAdd(this.noteList[position], "Düzenle",getPriorityColor(this.noteList[position].priority));
                    },
                  ),
                ),
                title: Text(
                  this.noteList[position].title,
                  style: TextStyle(
                    color: Color(0xe4ffffff),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                subtitle: Text(
                  this.noteList[position].date,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Color(0xe4ffffff),
                  ),
                  onTap: () {
                    _delete(context, noteList[position]);
                  },
                ),
                onTap: () {
                  String noteText;
                  String titleText;
                  titleText = this.noteList[position].title;
                  noteText = this.noteList[position].description;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadNoteScreen(
                        noteText: noteText,
                        titleText: titleText,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          navigateToAdd(Note('', '', 2, ''), "Yeni Başlık",Color(0xff64fad6));
        },
        label: Icon(
          Icons.add,
          size: 35,
          color: Color(0xe4ffffff),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      updateListView();
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Color(0xff64fad6);
        break;

      default:
        return Color(0xff64fad6);
    }
  }

  void navigateToAdd(Note note, String titleText, Color iconColour) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddScreen(note, titleText,iconColour);
        },
      ),
    );

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then(
      (database) {
        Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
        noteListFuture.then(
          (noteList) {
            setState(
              () {
                this.noteList = noteList;
                this.count = noteList.length;
              },
            );
          },
        );
      },
    );
  }
}
