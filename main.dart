import 'dart:math';

import 'package:flutter/material.dart';
import 'dog_model.dart';
import 'dog_bloc.dart';

List<Dog> dogs = [
  Dog(name: '푸들이'),
  Dog(name: '삽살이'),
  Dog(name: '말티말티'),
  Dog(name: '강돌이'),
  Dog(name: '진져'),
  Dog(name: '백구'),
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dog Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DogBloc bloc = DogBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: //리스트
          //파일 입출력 후 리스트 보여줄 것 => FutureBuilder 사용
          //FutureBuilder(
          //future: DBHelper().getAllDogs(), // 함수는 Future 로 반환된다.

          //BLoc 패턴 : StreamController 에 맞는 StreamBuilder 로 변경
          StreamBuilder(
        stream: bloc.dogs,

        //데이터는 builder 함수로 받아짐 //Snapshot : 한순간 받아진 데이터
        builder: (BuildContext context, AsyncSnapshot<List<Dog>> snapshot) {
          if (snapshot.hasData) {
            //snapshot 에 데이터가 있으면 List 반환

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Dog item = snapshot.data[index];

                //리스트의 element 들은 각각 Dismissible 로 구현됨
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    //DBHelper().deleteDog(item.id); //사라지면서 동시에 DB 에서도 사라지게
                    //setState(() {});

                    //bloc 형태로 변형 : 스와이프 시 deleteDog 함수 호출
                    bloc.deleteDog(item.id);
                  },
                  child: Center(child: Text(item.name)),
                );
              },
            );
          } else //snapshot 에 데이터가 없으면 로딩창 반환
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      //플로팅버튼(모두삭제, 하나추가)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              // DBHelper().deleteAllDogs(); //모두삭제
              // setState(() {});

              bloc.deleteAll();
            },
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              //Dog dog = dogs[Random().nextInt(dogs.length)];
              //DBHelper().createData(dog); //랜덤하게 추가
              //setState(() {});
              bloc.addDog(dogs[Random().nextInt(dogs.length)]);
            },
          ),
        ],
      ),
    );
  }
}
