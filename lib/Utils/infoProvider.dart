import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';

class InfoProvider {
  static String phone = '';
  static String name = '';
  static bool isExpert = false;

  void init(){
    Auth auth = Auth();
    DataStore dStore = DataStore();
  }
}
