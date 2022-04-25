class OutputData {
  List<dynamic> listData;
  OutputData(){
    listData = [];
  }

  addData(data){
    listData.add(data);
  }

  int getLength(){
    return listData.length;
  }

  String getResult(){
    var map = Map();
    listData.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    });
    var res = {'key' : '0' , 'value' : 0};
    map.forEach((key, value) {
      if(value>res['value']){
        res = {'key' : key , 'value' : value};
      }
    });

    return res['key'];
  }
}