import 'package:flutter/material.dart';
import 'package:frolo/blocs/application_bloc.dart';
import 'package:frolo/blocs/bloc_provider.dart';

class StatusEvent {
  bool noMore;
  int status;
  int cid;

  StatusEvent({this.noMore, this.status, this.cid});
}

class ComEvent {
  int id;
  Object data;

  ComEvent({
    this.id,
    this.data,
  });
}

class Event {
  static void sendAppEvent(BuildContext context, int id) {
    BlocProvider.of<ApplicationBloc>(context).sendAppEvent(id);
  }
}
