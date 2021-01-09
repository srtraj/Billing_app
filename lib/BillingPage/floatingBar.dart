import 'package:billing_app/MessagePage/msg.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:billing_app/InialPage/sizingConfig.dart';
import 'package:flutter/services.dart';

class FloatingBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FloatingBarWidgetState();
}

class FloatingBarWidgetState extends State<FloatingBarWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool backClr = true;
  static bool req = false;
  TextEditingController whatsappNum = new TextEditingController();

  static const List icons = [
    ["share", Icons.share],
    ["sms", Icons.sms],
    ["whatsapp", "asset/whatsapp.png"],
  ];

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  AddshowAlertDialog(BuildContext context) {
    // set up the buttons
    Widget updateButton = ListTile(
      title: Container(
        width: SizeConfig.width_factor * 40,
        child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
          ],
          decoration: InputDecoration(suffixIcon: Icon(Icons.contact_phone)),
          keyboardType: TextInputType.phone,
          controller: whatsappNum,
        ),
      ),
    );
    Widget cancelButton = FlatButton(
      child: Icon(Icons.cancel_presentation_sharp),
      onPressed: () => Navigator.pop(context, true),
    );
    Widget addButton = FlatButton(
      child: Icon(Icons.send_sharp),
      onPressed: () {
        if (whatsappNum.text.isNotEmpty)
          MessageToCust().sendwhatsapptoCust("+91${whatsappNum.text}");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enter valid Whatsapp Num"),
      content: updateButton,
      actions: [
        cancelButton,
        addButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  FloatFunction(var type) {
    switch (type) {
      case "sms":
        MessageToCust().sendSMStoCust();
        break;
      case "whatsapp":
        req = false;
        whatsappNum.text = "";
        AddshowAlertDialog(context);
        setState(() {});
        break;
      case "share":
        MessageToCust().shareFile();
        break;
    }
  }

  floatIconsDec(var type) {
    if (type[0] == "whatsapp") {
      return Image.asset(
        type[1],
        scale: 6,
      );
    } else {
      return Icon(
        type[1],
        color: Colors.white,
        size: SizeConfig.screen_height_factor * 5,
      );
    }
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: SizeConfig.screen_height_factor * 9,
          width: SizeConfig.screen_height_factor * 8,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.blue,
              child: floatIconsDec(icons[index]),
              onPressed: () {
                FloatFunction(icons[index][0]);
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          Container(
            height: SizeConfig.screen_height_factor * 9,
            width: SizeConfig.screen_height_factor * 8,
            child: FloatingActionButton(
              backgroundColor: backClr ? Colors.blue : Colors.red,
              heroTag: null,
              child: new AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform:
                        new Matrix4.rotationZ(_controller.value * math.pi * .5),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                      _controller.isDismissed ? Icons.share : Icons.close,
                    ),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
                backClr = !backClr;
                setState(() {});
              },
            ),
          ),
        ),
    );
  }
}
