import 'package:flutter/material.dart';

class ReadNoteScreen extends StatelessWidget {
  final String noteText;
  final String titleText;
  ReadNoteScreen({this.noteText,this.titleText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF555753),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          'Not',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22.0),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 5,left: 17,right: 17),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Color(0xFF2B2B2B),
                      borderRadius: BorderRadius.circular(30),
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                        right: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                        top: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      )),
                  child: Column(
                    children: [
                      Text(
                        '$titleText',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '\n$noteText',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 15,
                ),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.indigoAccent,
                  label: Text('Dön',style: TextStyle(color: Color(0xe4ffffff)),),
                  icon: Icon(Icons.keyboard_return, color: Color(0xe4ffffff),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
