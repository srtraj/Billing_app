import 'dart:typed_data';

import 'package:billing_app/InialPage/variableStore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_sms/flutter_sms.dart';

class MessageToCust {
  String message = billPrint();

  static String billPrint() {
    List<Map<String, String>> cartlist = VarStore.cartlist;
    var usrList = VarStore.list;
    String st;
    st = st = SpaceadjString(usrList["shop_name"], 50) +
        "\n" +
        SpaceadjString(usrList["place"], 50) +
        "\n" +
        SpaceadjString(usrList["pincode"].toString(), 50) +
        "\n" +
        SpaceadjString("Phone:+${usrList["phone"].toString()}", 50) +
        "\n";
    st = st + deviderFun("-", 40) + "\n";
    st = st +
        "No" +
        SpaceadjString("Item", 20) +
        SpaceadjString("Qty", 10) +
        SpaceadjString("Price", 10) +
        SpaceadjString("Total", 10) +
        "\n";

    st = st + deviderFun("-", 40);
    int ct = 0;
    for (var k in cartlist) {
      ct++;
      st = st +
          "\n$ct" +
          SpaceadjString(k["item"], 20) +
          SpaceadjString(k["weight"], 10) +
          "*" +
          SpaceadjString(k["price"], 10) +
          "=>" +
          SpaceadjString(k["cost"], 10) +
          "\n";
    }
    st = st + "\n" + deviderFun("=", 40);
    st = st +
        "\n" +
        "Total" +
        SpaceadjString(" ", 55) +
        VarStore.totalCost.toString();
    st = st + "\n" + deviderFun("=", 40);
    print(st);
    return st;
  }

  static String deviderFun(String st, int len) {
    String devider = "";
    for (int i = 0; i < len; i++) {
      devider = devider + st;
    }
    return devider;
  }

  static String SpaceadjString(String str, int len) {
    for (int i = 0; i < (len - str.length) / 2; i++) {
      str = " " + str + " ";
    }
    return str;
  }

  void sendwhatsapptoCust(String mobNum) {
    print("btn pressed");
    FlutterOpenWhatsapp.sendSingleMessage(mobNum, "asset/upi.png");
  }

  void sendSMStoCust() async {
    List<String> recipents = [VarStore.mob];
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    //  print(_result);
  }

  Future shareFile() async {
    ByteData bytes = await rootBundle.load('assets/upi.png');
    await Share.file(
        'upi image', 'upi.png', bytes.buffer.asUint8List(), 'image/png');
  }
}
