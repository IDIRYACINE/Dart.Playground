
import 'package:rxdart/rxdart.dart';

abstract class EventResolver<T extends BaseEvent> {
  void resolve(T event, void Function(T event) next);
}

abstract class BaseEvent{
  final int serviceId;
  final int eventId;

  BaseEvent(this.serviceId,this.eventId);
}


abstract class BaseService<T> {
  final PublishSubject<T> _subject = PublishSubject<T>();
  final int _id;

  BaseService(this._id);

  void next(T event) {
    _subject.add(event);
  }

  void error(Object error, [StackTrace? stackTrace]) {
    _subject.addError(error, stackTrace);
  }

  void complete() {
    _subject.close();
  }

  int get serviceId => _id;

  Stream<T> get stream => _subject.stream;
}
