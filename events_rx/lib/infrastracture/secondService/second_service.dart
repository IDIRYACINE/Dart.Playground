import 'package:playground/infrastracture/base.dart';

class SecondServiceEvent extends BaseEvent {
  SecondServiceEvent(super.serviceId, super.eventId);
}

class SecondEventResponse extends SecondServiceEvent {
  final String response;
  SecondEventResponse(super.serviceId, super.eventId, this.response);
}


class SecondServiceTestEvent extends SecondServiceEvent{
  SecondServiceTestEvent() :super(1,0);

}

class SecondEventResolver implements EventResolver<SecondServiceEvent> {
  @override
  void resolve(
      SecondServiceEvent event, void Function(SecondServiceEvent event) next) {
    print("SecondEventResolver");
    next(SecondEventResponse(
        event.serviceId, event.eventId, "SecondEventResolver"));
  }
}

class SecondService extends BaseService<SecondServiceEvent> {
  final List<EventResolver> _resolvers = [SecondEventResolver()];

  SecondService() : super(1);

  @override
  void next(SecondServiceEvent event) {
    _resolvers[event.eventId].resolve(event, (e) {
      super.next(SecondEventResponse(serviceId, 0, "response 2"));
    });
  }
}
