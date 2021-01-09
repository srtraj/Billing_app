import 'package:billing_app/BillingPage/billBody.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'billAppBar.dart';
import '../InialPage/sizingConfig.dart';
import 'floatingBar.dart';

class BillingPage extends StatelessWidget {
  static double bdHeight;
  double cost;
  int count;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[900],
          title: Text(
            "Bill",
            style: TextStyle(fontSize: SizeConfig.screen_height_factor * 5),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              SizeConfig.screen_height_factor * 20,
            ),
            child: Container(child: MyFlexiableAppBar()),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            SizeConfig().bodyHeight(constraints);
            return BillBody();
          },
        ),
        floatingActionButton: FloatingBarWidget(),
      ),
    );
  }
}
