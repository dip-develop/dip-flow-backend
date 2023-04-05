import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../domain/exceptions/exceptions.dart';
import '../domain/interfaces/interfaces.dart';
import '../domain/models/time_tracking_model.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/google/protobuf/timestamp.pb.dart';
import '../generated/time_tracking_models.pb.dart';
import '../generated/time_tracking_service.pbgrpc.dart';

@Singleton()
class TimeTrackingService extends TimeTrackingServiceBase {
  final TimeTrackingsUseCase _timeTrackings;

  TimeTrackingService(this._timeTrackings);

  @override
  Future<TimeTrackReply> getTimeTrack(
          ServiceCall call, GetTimeTrackRequest request) =>
      _timeTrackings
          .getTimeTracking(
            request.id,
          )
          .then((timeTrack) => TimeTrackReply(
              id: timeTrack.id,
              userId: timeTrack.userId,
              task: timeTrack.task,
              title: timeTrack.task,
              description: timeTrack.description,
              tracks: timeTrack.tracks.map((p0) => Track(
                  start: Timestamp.fromDateTime(p0.start),
                  end: p0.end != null
                      ? Timestamp.fromDateTime(p0.end!)
                      : null))))
          .catchError((onError) {
        if (onError is DbException) {
          call.sendTrailers(
              status: StatusCode.notFound, message: onError.message);
        } else {
          call.sendTrailers(status: StatusCode.unknown);
        }
      });

  @override
  Future<TimeTracksReply> getTimeTracks(
          ServiceCall call, GetTimeTracksRequest request) =>
      _timeTrackings
          .getTimeTrackings(
            request.userId,
          )
          .then((timeTracks) => TimeTracksReply(
              timeTracks: timeTracks.map((timeTrack) => TimeTrackReply(
                  id: timeTrack.id,
                  userId: timeTrack.userId,
                  task: timeTrack.task,
                  title: timeTrack.task,
                  description: timeTrack.description,
                  tracks: timeTrack.tracks.map((p0) => Track(
                      start: Timestamp.fromDateTime(p0.start),
                      end: p0.end != null
                          ? Timestamp.fromDateTime(p0.end!)
                          : null))))))
          .catchError((onError) {
        if (onError is DbException) {
          call.sendTrailers(
              status: StatusCode.notFound, message: onError.message);
        } else {
          call.sendTrailers(status: StatusCode.unknown);
        }
      });

  @override
  Future<TimeTrackReply> addTimeTrack(
      ServiceCall call, AddTimeTrackRequest request) {
    final completer = Completer<TimeTrackReply>();
    _timeTrackings
        .addTimeTracking(
            userId: request.userId,
            task: request.task,
            title: request.title,
            description: request.description)
        .then((timeTrack) {
      completer.complete(TimeTrackReply(
          id: timeTrack.id,
          userId: timeTrack.userId,
          task: timeTrack.task,
          title: timeTrack.task,
          description: timeTrack.description,
          tracks: timeTrack.tracks.map((p0) => Track(
              start: Timestamp.fromDateTime(p0.start),
              end: p0.end != null ? Timestamp.fromDateTime(p0.end!) : null))));
    }).catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
    });

    return completer.future;
  }

  @override
  Future<TimeTrackReply> updateTimeTrack(
      ServiceCall call, UpdateTimeTrackRequest request) {
    final completer = Completer<TimeTrackReply>();
    _timeTrackings
        .updateTimeTracking(
            id: request.id,
            task: request.task,
            title: request.title,
            description: request.description,
            tracks: request.tracks
                .map((e) => TrackModel(
                      (p0) => p0
                        ..start = e.start.toDateTime()
                        ..end = e.end.toDateTime(),
                    ))
                .toList())
        .then((timeTrack) {
      completer.complete(TimeTrackReply(
          id: timeTrack.id,
          userId: timeTrack.userId,
          task: timeTrack.task,
          title: timeTrack.task,
          description: timeTrack.description,
          tracks: timeTrack.tracks.map((p0) => Track(
              start: Timestamp.fromDateTime(p0.start),
              end: p0.end != null ? Timestamp.fromDateTime(p0.end!) : null))));
    }).catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
    });

    return completer.future;
  }

  @override
  Future<Empty> deleteTimeTrack(
          ServiceCall call, DeleteTimeTrackRequest request) =>
      _timeTrackings.deleteTimeTracking(request.id).then((_) => Empty());
}
