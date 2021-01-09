import 'package:auto_size_text/auto_size_text.dart';
import 'package:billing_app/InialPage/sizingConfig.dart';
import 'package:billing_app/InialPage/stringList.dart';
import 'package:billing_app/InialPage/variableStore.dart';
import 'package:billing_app/printPage/printPdfBillPage.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class BillBody extends StatefulWidget {
  @override
  _BillBodyState createState() => _BillBodyState();
}

class _BillBodyState extends State<BillBody> {
  static bool btnPress = true;
  static List<bool> list = [false, true];
  static List<bool> paid = [false, false];
  static bool keyEnter = false;

  TextEditingController name = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController email = TextEditingController();

  Widget paymentBtn(bool press, String st, String img) {
    return RaisedButton(
      elevation: press ? 20 : 0,
      color: press ? Colors.blue : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.blue[500],
        ),
      ),
      onPressed: () {
        btnPress = (st == "PayCash") ? true : false;
        setState(() {});
      },
      child: Container(
        width: SizeConfig.width_factor * 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.billBdHeight * 8,
              width: SizeConfig.width_factor * 15,
              child: Image.asset(
                img,
              ),
            ),
            AutoSizeText(
              st,
              style: TextStyle(
                fontSize: SizeConfig.billBdHeight * 2,
                color: press ? Colors.white : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget paymentOptionBtn() {
    if (keyEnter) {
      return Container();
    } else
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: SizeConfig.billBdHeight * 4),
          width: SizeConfig.width_factor * 85,
          height: SizeConfig.billBdHeight * 18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              paymentBtn(btnPress, "PayCash", "asset/cashPay.png"),
              paymentBtn(!btnPress, "PayOnline", "asset/upi.png"),
            ],
          ),
        ),
      );
  }

  Widget paidIndicateRow() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.billBdHeight * 2),
      child: Row(
        children: [
          Container(
            child: Text(
              "PAID:",
              style: TextStyle(
                  fontSize: SizeConfig.billBdHeight * 4,
                  fontWeight: FontWeight.bold),
            ),
            width: SizeConfig.width_factor * 28,
          ),
          Container(
            height: SizeConfig.billBdHeight * 5,
            child: ToggleButtons(
              borderColor: Colors.black,
              fillColor: Colors.grey,
              borderWidth: SizeConfig.width_factor * .5,
              selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              children: [
                Container(
                  width: SizeConfig.width_factor * 20,
                  child: Center(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          fontSize: SizeConfig.billBdHeight * 3,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.width_factor * 20,
                  child: Center(
                    child: Text(
                      'NO',
                      style: TextStyle(
                          fontSize: SizeConfig.billBdHeight * 3,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              isSelected: list,
              onPressed: (int index) {
                if (index == 0) {
                  list = [true, false];
                  paid = [true, false];
                } else {
                  list = [false, true];
                  paid[0] = false;
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget userDetailCol(String st, TextEditingController cnt) {
    return Container(
      height: SizeConfig.billBdHeight * 10,
      child: ListTile(
        title: Container(
          width: SizeConfig.width_factor * 40,
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  cnt == mob ? RegExp("[0-9.]") : RegExp('[a-zA-Z]'))
            ],
            decoration: InputDecoration(
                labelText: cnt.text.isEmpty
                    ? paid[0]
                        ? st
                        : cnt == email
                            ? st
                            : "$st*"
                    : "",
                labelStyle: TextStyle(
                    fontSize: SizeConfig.billBdHeight * 4,
                    color: !paid[1]
                        ? Colors.black
                        : cnt == email
                            ? Colors.black
                            : Colors.red),
                suffixIcon:
                    cnt == mob ? Icon(Icons.contact_phone) : Icon(null)),
            keyboardType: cnt == mob
                ? TextInputType.phone
                : cnt == email
                    ? TextInputType.emailAddress
                    : TextInputType.text,
            controller: cnt,
            onTap: () {
              keyEnter = true;
              setState(() {});
            },
            onChanged: VarStore().setUserDeatiles(st, cnt.text),
            onSubmitted: (_) => keyEnter = false,
          ),
        ),
      ),
    );
  }

  Widget billDetailes() {
    if (btnPress) {
      return Container(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.width_factor,
            SizeConfig.billBdHeight,
            SizeConfig.width_factor,
            SizeConfig.billBdHeight),
        child: Column(
          children: [
            paidIndicateRow(),
            Container(
              height: keyEnter ? 0 : SizeConfig.billBdHeight * 8,
            ),
            Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  userDetailCol(StringList.userDetaile["name"], name),
                  userDetailCol(StringList.userDetaile["mob"], mob),
                  userDetailCol(StringList.userDetaile["email"], email),
                ],
              ),
            ),
            Expanded(child: Container()),
            RaisedButton(
              onPressed: () {
                if ((mob.text.isEmpty || name.text.isEmpty) && !paid[0]) {
                  paid[1] =
                      true; //Customer name and mob no compulsory for non paid user
                  setState(() {});
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return PrintPage();
                    }),
                  );
                }
              },
              child: Container(
                width: SizeConfig.width_factor * 30,
                height: SizeConfig.billBdHeight * 10,
                child: Icon(
                  Icons.print,
                  size: SizeConfig.billBdHeight * 10,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget paymentContainer() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.billBdHeight * 3),
      child: Container(
        height: SizeConfig.billBdHeight * 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: billDetailes(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          keyEnter = false;
        }
        setState(() {});
      },
      child: Container(
        color: Colors.grey[200],
        child: Column(
          children: [paymentOptionBtn(), paymentContainer()],
        ),
      ),
    );
  }
}
