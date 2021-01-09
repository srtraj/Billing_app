import 'package:auto_size_text/auto_size_text.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:billing_app/BillingPage/billingPage.dart';
import 'package:billing_app/CommonWidget/drawerPage.dart';
import 'package:billing_app/InialPage/sizingConfig.dart';
import 'package:billing_app/InialPage/stringList.dart';
import 'package:billing_app/InialPage/variableStore.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'listPage.dart';

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final DatabaseReference database = FirebaseDatabase.instance.reference();
  String item, price, weight;
  String warningMsg = "";
  double totalCost;
  int totalItem = 0;
  static var items = {};
  List<TableRow> rows = [];
  static List<Map<String, String>> cartlist = [];
  TextEditingController itemController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  final focusWeight = FocusNode();
  final focusPrice = FocusNode();

  Future itemList() {
    var list = {};
    database.child("itemList").once().then((DataSnapshot dataSnapShot) async {
      items = await dataSnapShot.value;
    });
    database
        .child("userDetailes")
        .once()
        .then((DataSnapshot dataSnapShot) async {
      list = await dataSnapShot.value;
      VarStore().userDetailes(list);
    });

    setState(() {});
  }

  Widget addItembox(String name, TextEditingController x) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.width_factor,
            SizeConfig.height_factor,
            SizeConfig.width_factor,
            SizeConfig.height_factor),
        child: Row(
          children: [
            Container(
              child: AutoSizeText(
                name,
                style: TextStyle(fontSize: SizeConfig.height_factor * 5),
              ),
              width: SizeConfig.width_factor * 40,
            ),
            TextFielddecider(x),
          ],
        ),
      ),
    );
  }

  static List<String> getSuggestions(String query, List<String> states) {
    List<String> matches = List();
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Widget TextFielddecider(TextEditingController x) {
    List<String> list = List();
    items.forEach((k, v) => list.add(k));
    if (x == itemController) {
      return Expanded(
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            style: TextStyle(
                fontSize: SizeConfig.height_factor * 3,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: SizeConfig.width_factor * 2),
              border: OutlineInputBorder(),
            ),
            controller: itemController,
          ),
          suggestionsCallback: (pattern) async {
            return getSuggestions(pattern, list);
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            itemController.text = suggestion;
            priceController.text = items[suggestion].toString();
            FocusScope.of(context).requestFocus(focusWeight);
            if (cartlist.toString().contains(itemController.text)) {
              warningMsg = StringList.warningMsg["alreadyExist"];
            } else
              warningMsg = StringList.warningMsg["noError"];
          },
        ),
      );
    } else {
      return Expanded(
        child: TextField(
          style: TextStyle(
              fontSize: SizeConfig.height_factor * 3,
              fontWeight: FontWeight.bold),
          focusNode: x == weightController ? focusWeight : focusPrice,
          controller: x,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: SizeConfig.width_factor * 2),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
          ],
        ),
      );
    }
  }

  Widget addButton() {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.width_factor * 2),
      child: SizedBox(
        width: SizeConfig.width_factor * 20,
        child: FlatButton(
          padding: EdgeInsets.all(SizeConfig.height_factor),
          onPressed: () => itemDetailesCheck(),
          color: Colors.orange,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void itemDetailesCheck() {
    List<String> itlst = [];
    for (var k in cartlist) {
      itlst.add("<${k["item"]}>");
    }
    FocusScope.of(context).requestFocus(FocusNode());
    if (itemController.text == "" ||
        priceController.text == "" ||
        weightController.text == "") {
      warningMsg = StringList.warningMsg["allEmpty"];
    } else if (itlst.toString().contains("<${itemController.text}>")) {
      AddshowAlertDialog(context);
    } else if (double.parse(priceController.text) == 0) {
      warningMsg = StringList.warningMsg["priceEmpty"];
    } else if (double.parse(weightController.text) == 0) {
      warningMsg = StringList.warningMsg["weightEmpty"];
    } else {
      String cost = (double.parse(priceController.text) *
              double.parse(weightController.text))
          .toString();
      cartlist.insert(0, {
        "item": "${itemController.text}",
        "price": "${double.parse(priceController.text)}",
        "weight": "${double.parse(weightController.text)}",
        "cost": "$cost"
      });
      itemController.text = "";
      priceController.text = "";
      weightController.text = "";
      warningMsg = StringList.warningMsg["noError"];
      toastMsg(StringList.tostMsg["itemadded"], "CENTER");
    }
    setState(() {});
  }

  AddshowAlertDialog(BuildContext context) {
    // set up the buttons
    Widget updateButton = FlatButton(
      child: Text("Update"),
      onPressed: () {
        Navigator.pop(context, true);
        for (var k in cartlist) {
          if (k["item"] == itemController.text) {
            k.update(
                "weight", (value) => "${double.parse(weightController.text)}");
            k.update(
                "price", (value) => "${double.parse(priceController.text)}");
            k.update(
                "cost",
                (value) => (double.parse(priceController.text) *
                        double.parse(weightController.text))
                    .toString());
          }
        }
        itemController.text = "";
        priceController.text = "";
        weightController.text = "";
        warningMsg = StringList.warningMsg["noError"];
      },
    );
    Widget addButton = FlatButton(
      child: Text("Add"),
      onPressed: () {
        Navigator.pop(context, true);
        for (var k in cartlist) {
          if (k["item"] == itemController.text) {
            double wt =
                double.parse(weightController.text) + double.parse(k["weight"]);
            k.update("weight", (value) => wt.toString());
            k.update(
                "price", (value) => "${double.parse(priceController.text)}");
            k.update(
                "cost",
                (value) =>
                    (double.parse(priceController.text) * wt).toString());
          }
        }
        itemController.text = "";
        priceController.text = "";
        weightController.text = "";
        warningMsg = StringList.warningMsg["noError"];
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.pop(context, true),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text(StringList.alertMsg["alreadyExist"]),
      actions: [
        updateButton,
        addButton,
        cancelButton,
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

  Widget cartTable() {
    totalCost = 0;
    double fntsize = SizeConfig.height_factor * 3;
    if (rows.isEmpty) {
      rows.add(TableRow(children: [
        Center(
            child: AutoSizeText(
          "item",
          style: TextStyle(fontSize: fntsize, fontWeight: FontWeight.bold),
        )),
        Center(
            child: AutoSizeText("price/kg",
                style:
                    TextStyle(fontSize: fntsize, fontWeight: FontWeight.bold))),
        Center(
            child: AutoSizeText("weight",
                style:
                    TextStyle(fontSize: fntsize, fontWeight: FontWeight.bold))),
        Center(
            child: AutoSizeText("cost",
                style:
                    TextStyle(fontSize: fntsize, fontWeight: FontWeight.bold))),
        Container(),
      ]));
    }
    for (var k in cartlist) {
      rows.add(TableRow(children: [
        Center(child: Text(k["item"], style: TextStyle(fontSize: fntsize))),
        Center(child: Text(k["price"], style: TextStyle(fontSize: fntsize))),
        Center(child: Text(k["weight"], style: TextStyle(fontSize: fntsize))),
        Center(child: Text(k["cost"], style: TextStyle(fontSize: fntsize))),
        InkWell(
          onTap: () {
            showAlertDialog(context, k);
          },
          child: Center(
            child: Icon(
              Icons.cancel,
              size: fntsize,
              color: Colors.black,
            ),
          ),
        ),
      ]));
      totalCost = totalCost + double.parse(k["cost"]);
    }
    totalItem = cartlist.length;
    return cartlist.length == 0
        ? Container()
        : Table(
            columnWidths: {
                4: FixedColumnWidth(
                    SizeConfig.width_factor * 10), // fixed to 100 width
              },
            border: TableBorder.all(width: 1.0, color: Colors.red),
            children: rows);
  }

  showAlertDialog(BuildContext context, var k) {
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context, true);
        cartlist.removeAt(cartlist.indexOf(k));
        setState(() {});
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.pop(context, true),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text(StringList.alertMsg["deleteRow"]),
      actions: [
        okButton,
        cancelButton,
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

  void toastMsg(String msg, String grav) {
    ToastGravity g =
        grav == "BOTTOM" ? ToastGravity.BOTTOM : ToastGravity.CENTER;
    Color bk = grav == "BOTTOM" ? Colors.black : Colors.grey[100];
    Color tc = grav == "BOTTOM" ? Colors.white : Colors.black;
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: g, // also possible "TOP" and "CENTER"
      backgroundColor: bk,
      textColor: tc,
      fontSize: SizeConfig.height_factor * 2,
    );
  }

  @override
  void initState() {
    itemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().body_Height(constraints);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.Body_height_factor * 5),
            child: AppBar(
              title: Text(
                StringList.titlename,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: SizeConfig.Body_height_factor * 3),
              ),
            ),
          ),
          drawer: DrawerPage(),
          body: LayoutBuilder(
            builder: (context, constraints) {
              SizeConfig().body_ExpectAppbar_Height(constraints);
              return Column(
                children: [
                  Container(
                    color: Colors.lightBlueAccent,
                    height: SizeConfig.height_factor * 40,
                    padding: EdgeInsets.all(SizeConfig.width_factor),
                    child: Column(
                      children: [
                        addItembox(
                            StringList.textFieldName["item"], itemController),
                        addItembox(
                            StringList.textFieldName["price"], priceController),
                        addItembox(StringList.textFieldName["weight"],
                            weightController),
                        Row(
                          children: [
                            AutoSizeText(
                              warningMsg,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.width_factor * 4),
                            ),
                            Expanded(child: Container()),
                            addButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  cartlist.isEmpty
                      ? Container(
                          height: SizeConfig.height_factor * 4,
                        )
                      : Container(
                          color: Colors.grey[350],
                          height: SizeConfig.height_factor * 4,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.width_factor * 2,
                                right: SizeConfig.width_factor * 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  "cost=$totalCost Items=$totalItem",
                                  style: TextStyle(
                                      fontSize: SizeConfig.height_factor * 2),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ListPage(cartlist);
                                      }),
                                    );
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.aspect_ratio_sharp,
                                      size: SizeConfig.height_factor * 4,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Container(
                    color: Colors.green,
                    height: SizeConfig.height_factor * 51,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Container(
                          child: cartTable(),
                        ),
                      ),
                    ),
                  ),
                  cartlist.length == 0
                      ? Container()
                      : Container(
                          height: 5 * SizeConfig.height_factor,
                          color: Colors.deepOrange[400],
                          child: InkWell(
                            onTap: () async {
                              VarStore()
                                  .setTotalCostCount(totalCost, totalItem);
                              VarStore().setCartList(cartlist);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return BillingPage();
                                }),
                              );
                            },
                            child: Center(
                                child: AutoSizeText(
                              "PROCEED TO BILL",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.height_factor * 3),
                            )),
                          ),
                        ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
