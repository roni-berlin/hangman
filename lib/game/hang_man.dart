import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/widget/log_out_widget.dart';
import 'WordGenerator.dart';
import 'dart:math';

String lv1 = 'images/1.png';
String lv2 = 'images/2.png';
String lv3 = 'images/3.png';
String lv4 = 'images/4.png';
String lv5 = 'images/5.png';
String lv6 = 'images/6.png';
String lv7 = 'images/7.png';
List<String> levels = [lv1, lv2, lv3, lv4, lv5, lv6, lv7];
String pressedLetters = "";
int level = 0;
int numOfGuessing = 0;
final user = FirebaseAuth.instance.currentUser;

var rng = new Random();
int randCategory = rng.nextInt(WordGenerator.category.length);
String answer = WordGenerator.wordGen(randCategory);
String hint = WordGenerator.category[randCategory];
String qst = hideWord(answer);

String hideWord(String answer) {
  String hideWord = answer;
  for (int letter = 0; letter < hideWord.length; letter++) {
    if (hideWord[letter] != ' ') {
      hideWord =
          hideWord.substring(0, letter) + '_' + hideWord.substring(letter + 1);
    }
  }
  return hideWord;
}

class HangMan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor:Colors.lightBlue.shade300),
      title: 'Hang-Man',
      home: MyHomePage(
        title: 'איש-תלוי',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void upLvl() {
    setState(() {
      if (level == levels.length - 1) {
        level = 0;
        pressedLetters = "";
        randCategory = rng.nextInt(WordGenerator.category.length);
        answer = WordGenerator.wordGen(randCategory);
        hint = WordGenerator.category[randCategory];
        qst = hideWord(answer);
        int gesToShow = numOfGuessing;
        numOfGuessing = 0;
        showLoseDialog(gesToShow);
      } else {
        level++;
      }
    });
  }

  void revealLetter(String text) {
    setState(() {
      for (int letter = 0; letter < answer.length; letter++) {
        if (answer[letter] == text) {
          qst = qst.substring(0, letter) + text + qst.substring(letter + 1);
        }
      }
    });
    if (!qst.contains('_')) {
      level = 0;
      pressedLetters = "";
      randCategory = rng.nextInt(WordGenerator.category.length);
      answer = WordGenerator.wordGen(randCategory);
      hint = WordGenerator.category[randCategory];
      qst = hideWord(answer);
      numOfGuessing++;
      showWinDialog();
    }
  }

  showWinDialog() {
    Timer _timer;
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
        _timer  = Timer(Duration(milliseconds: 500), () {
            Navigator.of(context, rootNavigator: true).pop();
          });

          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 225),
              title: Text('✅',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 80,color: Colors.blueGrey[900])));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  showLoseDialog(int gesToShow) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark(),
          child: CupertinoAlertDialog(
            title: Text("המשחק נגמר ☹",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Miriwin',
                  fontWeight: FontWeight.bold,
                )),
            content: Text("ניקוד: " + gesToShow.toString(),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Miriwin',
                  fontWeight: FontWeight.bold,
                )),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('שחק שוב',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Miriwin',
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.lightBlue.shade300,
          centerTitle: true,
          actions: [
        FlatButton(
        child:
        CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(user.photoURL),
              ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoggedOutWidget()),
            );
          },
            ),
          ],
          title: Text(
              widget.title,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.blueGrey[900],
                fontFamily: 'Miriwin',
                fontWeight: FontWeight.bold,
              )),
        ),
        body: Center(
            child: Column(children: <Widget>[
              Image.asset(levels[level]),
              Text('ניקוד: ' + numOfGuessing.toString(),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.blueGrey[900],
                      fontFamily: 'Miriwin',
                      wordSpacing: 5.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold)),
              Text(hint,
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 40,
                  )),
              Text(qst,
                  textDirection: TextDirection.rtl,
                  style: TextStyle( fontFamily: 'Miriwin',  fontWeight: FontWeight.bold, fontSize: 40, letterSpacing: 15.0, color: Colors.blueGrey[900])),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                button('ח', upLvl, revealLetter),
                button('ז', upLvl, revealLetter),
                button('ו', upLvl, revealLetter),
                button('ה', upLvl, revealLetter),
                button('ד', upLvl, revealLetter),
                button('ג', upLvl, revealLetter),
                button('ב', upLvl, revealLetter),
                button('א', upLvl, revealLetter),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                button('נ', upLvl, revealLetter),
                button('ם', upLvl, revealLetter),
                button('מ', upLvl, revealLetter),
                button('ל', upLvl, revealLetter),
                button('ך', upLvl, revealLetter),
                button('כ', upLvl, revealLetter),
                button('י', upLvl, revealLetter),
                button('ט', upLvl, revealLetter),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                button('ק', upLvl, revealLetter),
                button('ץ', upLvl, revealLetter),
                button('צ', upLvl, revealLetter),
                button('ף', upLvl, revealLetter),
                button('פ', upLvl, revealLetter),
                button('ע', upLvl, revealLetter),
                button('ס', upLvl, revealLetter),
                button('ן', upLvl, revealLetter),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                button('ת', upLvl, revealLetter),
                button('ש', upLvl, revealLetter),
                button('ר', upLvl, revealLetter)
              ]),
            ])));
  }
}

ButtonTheme button(String text, Function upLvl, Function revealLetter) {
  Color color = Colors.orange.shade400;
  if (pressedLetters.contains(text)) {
    answer.contains(text)
        ? color = Colors.greenAccent
        : color = Colors.red[400];
  }

  return ButtonTheme(
      minWidth: 48.0,
      height: 20.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        textColor:Colors.lightBlue.shade300,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.blueGrey[900],
        onPressed: () => {
          if (!pressedLetters.contains(text))
            {
              pressedLetters += text,
              answer.contains(text) ? revealLetter(text) : upLvl()
            },
        },
        color: color,
        child: Column(//
            children: <Widget>[
              Text(text, style: TextStyle(fontSize: 25, color: Colors.blueGrey[900])),
            ]),
      ));
}
