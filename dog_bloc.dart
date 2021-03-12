import 'dart:async';

import 'package:flutter_sqlite_practice_dog/db_helper.dart';

import 'dog_model.dart';

//Bloc 패턴으로 데이터와 뷰의 갱신 담당하기

//입구(sink)로는 데이터를 넣고, 출구(stream)로는 데이터를 받아서 Widget 을 갱신
//입구는 여러개일 수 있지만, 반응하는 출구는 1개로 인식되며, 출구를 여러개로 바꿀때는 broadcast를 이용
//StreamController : 입구와 출구를 관리 및 쉽게 접근할 수 있게 해주는 클래스
class DogBloc {

  DogBloc(){
    getDogs();    //기존 데이터 그대로 불러오기 : 생성자에서 데이터 호출
    //생성자에는 async 사용 불가능 --> getDogs 함수 만들어서 사용용
 }

  final _dogsController = StreamController<List<Dog>>.broadcast();
  get dogs => _dogsController.stream;

  dispose() {
    _dogsController.close();
  }

  getDogs() async {
    _dogsController.sink.add(await DBHelper().getAllDogs());
  }

  addDog(Dog dog) async{
    await DBHelper().createData(dog);
    _dogsController.sink.add(await DBHelper().getAllDogs()); //리스트 형태로 sink 에 여러 개 데이터 넣음
  }

  deleteDog(int id) async {
    await DBHelper().deleteDog(id);
    _dogsController.sink.add(await DBHelper().getAllDogs());
  }

  deleteAll() async {
    await DBHelper().deleteAllDogs();
    _dogsController.sink.add(await DBHelper().getAllDogs());
  }


}