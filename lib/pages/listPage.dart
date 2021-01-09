import 'package:auto_size_text/auto_size_text.dart';
import 'file:///F:/Flutter_project/billing_app/lib/InialPage/sizingConfig.dart';
import "package:flutter/material.dart";

import '../InialPage/stringList.dart';

class ListPage extends StatelessWidget {
  List<Map<String, String>> list;
  ListPage(this.list);

  Widget cartTable() {
    List<TableRow> rows = [];
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
      ]));
    }
    for (var k in list) {
      rows.add(TableRow(children: [
        Center(child: Text(k["item"], style: TextStyle(fontSize: fntsize))),
        Center(child: Text(k["price"], style: TextStyle(fontSize: fntsize))),
        Center(child: Text(k["weight"], style: TextStyle(fontSize: fntsize))),
        Center(child: Text(k["cost"], style: TextStyle(fontSize: fntsize))),
      ]));
    }
    return Table(columnWidths: {
      4: FixedColumnWidth(SizeConfig.width_factor * 10), // fixed to 100 width
    }, border: TableBorder.all(width: 1.0, color: Colors.red), children: rows);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              title: Container(
                child: Text(
                  StringList.titlename,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.add_shopping_cart_sharp),
                  onPressed: () {},
                ),
              ]),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                child: cartTable(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
