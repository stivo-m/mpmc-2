import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mpmc/chat/bloc/bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const <dynamic>[]]) : super(props);
}

class SendMessage extends ChatEvent {
  final String sender, message, recipient;
  SendMessage(
      {@required this.sender, @required this.message, @required this.recipient})
      : super([sender, message, recipient]);
}

class CheckNotifications extends ChatEvent {
  final String from;
  CheckNotifications({@required this.from}) : super([from]);
}

class TypingMessage extends ChatState {
  final bool isTyping;

  TypingMessage({this.isTyping = false}) : super([isTyping]);
}
