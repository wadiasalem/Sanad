import 'package:shared_preferences/shared_preferences.dart';

class settingsInterface {
  String language;
  String character;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  settingsInterface(){
    _prefs.then((SharedPreferences prefs) {
      return (prefs.getString("language") ?? "FR");
    }).then((String language){
          this.language = language ;
        _prefs.then((SharedPreferences prefs) {
          return  (prefs.getString("character") ?? ((language=="AR")?"karim":"alain"));
        }).then((String character){
          this.character = character;
        });

    });
  }

  setSettings(language,character){
    this.language = language ;
    this.character = character;
    saveData();

  }

  setCharacter(character){
    this.character = character;
    saveData();
  }

  setLanguage(language){
    this.language = language;
    saveData();
  }

  saveData(){
    _prefs.then((SharedPreferences prefs) {
      prefs.setString("language",language);
      prefs.setString("character",character);
    });
  }
}