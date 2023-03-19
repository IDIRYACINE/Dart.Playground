
import 'package:playground/infrastracture/base.dart';

class FirstServiceEvent extends BaseEvent{
  FirstServiceEvent(super.serviceId, super.eventId);
}

class FirstServiceTestEvent extends FirstServiceEvent{
  FirstServiceTestEvent() :super(0,0);

}

class FirstEventResponse extends FirstServiceEvent{
  final String response;
  FirstEventResponse(super.serviceId, super.eventId, this.response);
}

class FirstResolver implements EventResolver<FirstServiceEvent>{
  @override
  void resolve(FirstServiceEvent event, void Function(FirstServiceEvent event) next) {
    print("FirstResolver");
    next(FirstEventResponse(event.serviceId, event.eventId, "FirstResolver"));
  }

}

class FirstService extends BaseService<FirstServiceEvent>{
  final List<EventResolver> _resolvers = [FirstResolver()];

  FirstService() :super(0);

  @override
  void next(FirstServiceEvent event) {
    _resolvers[event.eventId].resolve(event, (e){
      super.next(FirstEventResponse(serviceId, 0, "response 1"));
    });
  }

}