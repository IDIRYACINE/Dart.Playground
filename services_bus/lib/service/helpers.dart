import 'package:services_bus/search_algorithms/binary_search.dart';

import 'base.dart';

class EventResolverComparator
    extends BinarySearchComparator<EventResolver, int> {
  EventResolverComparator()
      : super(
            isGreaterThan: (source, target) => source.eventId > target,
            isLessThan: (source, target) => source.eventId < target);
}

BinarySearchAlgorithm<EventResolver<BaseEvent>, int>
    eventResolverBinarySearch() {
  return BinarySearchAlgorithm<EventResolver, int>(EventResolverComparator());
}
