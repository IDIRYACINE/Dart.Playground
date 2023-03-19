

import 'package:playground/infrastracture/firstService/first_service.dart';
import 'package:playground/infrastracture/services.dart';

import 'infrastracture/secondService/second_service.dart';


class Watcher{
  void init(ServiceGatewy gatewy,String name,int id){
    gatewy.listen(id).listen((event) {
      
      print("$name : ${event.response}");
    });
  }
}

void main(List<String> args) {


  final gateway = ServiceGatewy();

  final watcher1 = Watcher();
  final watcher2 = Watcher();

  watcher1.init(gateway, "Watcher1", 0);
  watcher2.init(gateway, "Watcher2", 1);

  gateway.next(FirstServiceTestEvent());

  gateway.next(SecondServiceTestEvent());


}