import 'package:billing_app/InialPage/stringList.dart';
import 'package:firebase_database/firebase_database.dart';

class VarStore {
  final DatabaseReference database = FirebaseDatabase.instance.reference();
  static double totalCost = 0;
  static int totalCount = 0;
  static String name = "";
  static String mob = "";
  static String email = "";
  static List<Map<String, String>> cartlist = [];
  static var list = {};

  userDetailes(var ls) {
    list = ls;
  }

  setTotalCostCount(double cost, int count) {
    totalCost = cost;
    totalCount = count;
  }

  setCartList(List<Map<String, String>> list) {
    cartlist = list;
  }

  setUserDeatiles(String st, String data) {
    if (StringList.userDetaile["name"] == st) {
      name = data;
    } else if (StringList.userDetaile["mob"] == st) {
      mob = data;
    } else if (StringList.userDetaile["email"] == st) {
      email = data;
    }
  }
}
