import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventsEvent extends Equatable {
  EventsEvent([List props = const <dynamic>[]]) : super(props);
}

class AddEvent extends EventsEvent {
  final String venue, description, date, theme;

  AddEvent(
      {@required this.venue,
      @required this.description,
      @required this.date,
      @required this.theme})
      : super([venue, description, date, theme]);
}

class DeleteEvent extends EventsEvent {
  final String id;
  DeleteEvent({@required this.id}) : super([id]);
}
