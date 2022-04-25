import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  SharedPreferences _prefs;

  Settings(){
    init();
  }

  init()async{
    _prefs = await SharedPreferences.getInstance();
  }


  String getCharacter() {
      return (_prefs.getString("Character") ?? "karim");
  }

  Future setCharacter(characterName) async{
    final SharedPreferences prefs = await _prefs;
    return prefs.setString("Character",characterName) ;
  }
}