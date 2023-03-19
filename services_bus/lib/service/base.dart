import 'package:rxdart/rxdart.dart';
import 'package:services_bus/services_bus.dart';

int _servicesCurrId = -1;
int get servicesCurrId => _servicesCurrId++;

typedef ResponseCallback = void Function(BaseResponse response);

abstract class EventResolver<T extends BaseEvent> {
  final int eventId;
  final int serviceId;

  EventResolver(this.eventId, this.serviceId);

  void resolve(T event, ResponseCallback next);
}

abstract class BaseCommand<R extends BaseResponse, P extends BaseParameters> {
  final int commandId;

  BaseCommand(this.commandId);

  R execute(P);
}

abstract class BaseResponse {}

abstract class BaseParameters {}

abstract class BaseEvent {
  final int serviceId;
  final int eventId;

  BaseEvent(this.serviceId, this.eventId);
}

abstract class BaseService<T extends BaseEvent> {
  final PublishSubject<BaseResponse> _subject = PublishSubject<BaseResponse>();
  final List<EventResolver<T>> resolvers;

  final BinarySearchAlgorithm<EventResolver<BaseEvent>, int> searchAlgorithm =
      eventResolverBinarySearch();

  final int serviceId;

  int _currResolverId = -1;

  BaseService({required this.serviceId, this.resolvers = const []});

  void sendEvent(T event);

  void next(BaseResponse response) {
    _subject.add(response);
  }

  void error(Object error, [StackTrace? stackTrace]) {
    _subject.addError(error, stackTrace);
  }

  void complete() {
    _subject.close();
  }

  Stream<BaseResponse> get stream => _subject.stream;

  int get currResolverId => _currResolverId++;
}

abstract class BaseStore {
  final List<BaseService> services;

  final SearchAlgorithm searchAlgorithm = serviceBinarySearch();

  final int storeId;

  BaseStore(
      {required this.storeId,
       this.services = const [],
      });

  void next(BaseEvent event) {
    final service = searchAlgorithm.search(services, event.serviceId);
    if (service != null) {
      service.next(event);
    }
  }

  Stream<BaseEvent> serviceStream(int serviceId) {
    final service = searchAlgorithm.search(services, serviceId);
    if (service != null) {
      return service.stream;
    }
    return Stream.empty();
  }

  void registerService(BaseService service) {
    services.add(service);
  }
}
