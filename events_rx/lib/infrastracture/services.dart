import 'package:playground/infrastracture/base.dart';
import 'package:playground/infrastracture/firstService/first_service.dart';
import 'package:playground/infrastracture/secondService/second_service.dart';

class ServiceGatewy {
  ServiceGatewy() {
    _registerBaseServices();
  }

  final List<BaseService> _services = [];

  void registerService(BaseService service) {
    _services.add(service);
  }

  void unregisterService(BaseService service) {
    _services.remove(service);
  }

  void _registerBaseServices() {
    registerService(FirstService());
    registerService(SecondService());
  }

  void next(BaseEvent event) {
    _services[event.serviceId].next(event);
  }

  Stream listen(int id){
    return _services[id].stream;
  }


}
