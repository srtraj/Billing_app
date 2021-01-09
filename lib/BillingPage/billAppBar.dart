import 'package:billing_app/InialPage/sizingConfig.dart';
import 'package:billing_app/InialPage/variableStore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyFlexiableAppBar extends StatelessWidget {
  MyFlexiableAppBar();

  int bilNo = 0;
  var date = new DateTime.now().toString();
  getCurrentDate() {
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formattedDate.toString();
  }

  getBillNo() {
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}${dateParse.month}${dateParse.year}";
    return "$bilNo/$formattedDate";
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: new Text("Total Amount",
                        style: TextStyle(
                            color: Colors.white.withOpacity(.6),
                            fontFamily: 'Poppins',
                            fontSize: SizeConfig.screen_height_factor * 3)),
                  ),
                  Container(
                    child: new Text("\u{20B9}${VarStore.totalCost}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 36.0)),
                  ),
                ],
              ),
            ),
            Container(
              child: SizedBox(
                height: SizeConfig.screen_height_factor * 3,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.screen_height_factor,
                          left: SizeConfig.width_factor * 2),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "BillNo#",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        SizeConfig.screen_height_factor * 2.1)),
                            TextSpan(
                                text: "${getBillNo()}",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.7),
                                    fontSize:
                                        SizeConfig.screen_height_factor * 2))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.screen_height_factor,
                          right: SizeConfig.width_factor * 2),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                FontAwesomeIcons.calendarAlt,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width_factor,
                            ),
                            Container(
                              child: Text(
                                getCurrentDate(),
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.6),
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        SizeConfig.screen_height_factor * 2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
