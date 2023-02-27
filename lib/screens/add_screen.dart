import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todosapp/models/task_model.dart';
import 'package:todosapp/database/db_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todosapp/admob_service.dart';

class AddScreen extends StatefulWidget {
  final Note note;
  final String titleText;
  final Color iconColour;

  AddScreen(this.note,this.titleText,this.iconColour);

  @override
  State<StatefulWidget> createState() {
    return AddScreenState(this.note,this.titleText,this.iconColour);
  }
}

class AddScreenState extends State<AddScreen> {
  static var _priorities = ['Yüksek', 'Düşük'];

  DatabaseHelper helper = DatabaseHelper();

  Note note;
  String titleText;
  Color iconColour;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AddScreenState(this.note,this.titleText,this.iconColour);
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
      size: AdSize.largeBanner,
      listener: AdListener(
          onAdLoaded: (_) {
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (_,error) {
            print("Ad Failed to Load with Error : $error");
          }
      ),

    );

    _ad.load();
  }

  Widget checkForAd() {

      return Container(
        child: AdWidget(
          ad: _ad,
        ),
        width: 320,
        height: 100,
        alignment: Alignment.center,
        //margin: EdgeInsets.only(left: 55),
      );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {

        Navigator.pop(context, true);
      },
      child: Scaffold(
        backgroundColor: Color(0xFF2B2B2B),
        appBar: AppBar(
          title: Text(titleText),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.crop_din_outlined,color: iconColour,),

                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(
                          () {
                        debugPrint('User selected $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser);
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  controller: titleController,
                  style: textStyle,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Başlık',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.center,
                  minLines: 3,
                  maxLines: 6,
                  style: textStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Not',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                // ignore: deprecated_member_use
                child: FlatButton(
                  color: Colors.indigoAccent,
                  textColor: Color(0xe4ffffff),
                  child: Text(
                    'Kaydet',
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    setState(
                          () {
                        debugPrint("Save button clicked");
                        _save();
                      },
                    );
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 100),
                child: checkForAd(),)
            ],
          ),
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Yüksek':
        iconColour = Colors.red;
        note.priority = 1;
        break;
      case 'Düşük':
        iconColour = Color(0xff64fad6);
        note.priority = 2;
        break;
    }
  }


  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }


  void updateTitle() {
    note.title = titleController.text;
  }


  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    Navigator.pop(context, true);

    note.date = DateFormat.yMMMd().format(DateTime.now());
    //int result;
    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }
}
