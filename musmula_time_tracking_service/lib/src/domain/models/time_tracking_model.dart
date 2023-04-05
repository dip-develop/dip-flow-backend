import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'time_tracking_model.g.dart';

abstract class TimeTrackingModel
    implements Built<TimeTrackingModel, TimeTrackingModelBuilder> {
  int? get id;
  int get userId;
  String? get task;
  String? get title;
  String? get description;
  BuiltList<TrackModel> get tracks;

  TimeTrackingModel._();
  factory TimeTrackingModel([void Function(TimeTrackingModelBuilder) updates]) =
      _$TimeTrackingModel;
}

abstract class TrackModel implements Built<TrackModel, TrackModelBuilder> {
  DateTime get start;
  DateTime? get end;

  TrackModel._();
  factory TrackModel([void Function(TrackModelBuilder) updates]) = _$TrackModel;
}
