
import 'package:rxdart/rxdart.dart';
import 'package:services_bus/search_algorithms/search.dart';

abstract class EventResolver<T extends BaseEvent> {
  final int eventId;

  EventResolver(this.eventId);

  void resolve(T event, void Function(T event) next);
}

abstract class BaseCommand<R extends BaseResponse , P extends BaseParameters>{
  final int commandId;

  BaseCommand(this.commandId);

  R execute(P);

}

abstract class BaseResponse {

}

abstract class BaseParameters{

}

abstract class BaseEvent{
  final int serviceId;
  final int eventId;

  BaseEvent(this.serviceId,this.eventId);
}


abstract class BaseService<T extends BaseEvent> {
  final PublishSubject<T> _subject = PublishSubject<T>();
  final List<EventResolver<T>> resolvers;

  final SearchAlgorithm searchAlgorithm ;

  final int id;

  int _currResolverId = -1;

  BaseService({required this.id, required this.resolvers, required this.searchAlgorithm});

  void next(T event) {
    _subject.add(event);
  }

  void error(Object error, [StackTrace? stackTrace]) {
    _subject.addError(error, stackTrace);
  }

  void complete() {
    _subject.close();
  }

  Stream<T> get stream => _subject.stream;

  int get currResolverId => _currResolverId++;
}



abstract class BaseStore {
  final List<BaseService> services;

  final SearchAlgorithm searchAlgorithm ;

  final int id;

  int _servicesCurrId = -1;
  

  BaseStore({required this.id, required this.services, required this.searchAlgorithm});

  void next(BaseEvent event) {
    final service = searchAlgorithm.search(services, event.serviceId);
    if (service != null){
      service.next(event);
    }
  }

  Stream<BaseEvent> serviceStream(int serviceId) {
    final service = searchAlgorithm.search(services, serviceId);
    if (service != null){
      return service.stream;
    }
    return Stream.empty();
  }

  void registerService(BaseService service) {
    services.add(service);
  }

  int get servicesCurrId => _servicesCurrId++;
}

