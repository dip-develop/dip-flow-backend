import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../domain/exceptions/exceptions.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/base_models.pb.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/google/protobuf/timestamp.pb.dart';
import '../generated/time_tracking_models.pb.dart';
import '../generated/time_tracking_service.pbgrpc.dart';

@Singleton()
class TimeTrackingService extends TimeTrackingServiceBase {
  final TimeTrackingsUseCase _timeTrackings;

  TimeTrackingService(this._timeTrackings);

  @override
  Future<TimeTrackReply> getTimeTrack(ServiceCall call, IdRequest request) {
    final completer = Completer<TimeTrackReply>();

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
            tracks: timeTrack.tracks.map((p0) => TrackReply(
                id: p0.id,
                start: Timestamp.fromDateTime(p0.start),
                end: p0.end != null ? Timestamp.fromDateTime(p0.end!) : null))))
        .then((value) => completer.complete(value))
        .catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });
    return completer.future;
  }

  @override
  Future<TimeTracksReply> getTimeTracks(
      ServiceCall call, GetTimeTrackRequest request) {
    final completer = Completer<TimeTracksReply>();
    _timeTrackings
        .getTimeTrackings(
            userId: request.userId,
            offset: request.offset,
            limit: request.limit)
        .then((timeTracks) => TimeTracksReply(
            count: timeTracks.count,
            limit: timeTracks.limit,
            offset: timeTracks.offset,
            timeTracks: timeTracks.items.map((timeTrack) => TimeTrackReply(
                id: timeTrack.id,
                userId: timeTrack.userId,
                task: timeTrack.task,
                title: timeTrack.task,
                description: timeTrack.description,
                tracks: timeTrack.tracks.map((p0) => TrackReply(
                    id: p0.id,
                    start: Timestamp.fromDateTime(p0.start),
                    end: p0.end != null
                        ? Timestamp.fromDateTime(p0.end!)
                        : null))))))
        .then((value) => completer.complete(value))
        .catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });

    return completer.future;
  }

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
          title: timeTrack.title,
          description: timeTrack.description,
          tracks: timeTrack.tracks.map((p0) => TrackReply(
              id: p0.id,
              start: Timestamp.fromDateTime(p0.start),
              end: p0.end != null ? Timestamp.fromDateTime(p0.end!) : null))));
    }).catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
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
    )
        .then((timeTrack) {
      completer.complete(timeTrack.toReply());
    }).catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });

    return completer.future;
  }

  @override
  Future<Empty> deleteTimeTrack(ServiceCall call, IdRequest request) =>
      _timeTrackings.deleteTimeTracking(request.id).then((_) => Empty());

  @override
  Future<TimeTrackReply> startTrack(ServiceCall call, IdRequest request) {
    final completer = Completer<TimeTrackReply>();
    _timeTrackings
        .startTrack(
          request.id,
        )
        .then((timeTrack) => timeTrack.toReply())
        .then((value) => completer.complete(value))
        .catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });
    return completer.future;
  }

  @override
  Future<TimeTrackReply> stopTrack(ServiceCall call, IdRequest request) {
    final completer = Completer<TimeTrackReply>();
    _timeTrackings
        .stopTrack(
          request.id,
        )
        .then((timeTrack) => timeTrack.toReply())
        .then((value) => completer.complete(value))
        .catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });
    return completer.future;
  }

  @override
  Future<TimeTrackReply> deleteTrack(
      ServiceCall call, DeleteTrackRequest request) {
    final completer = Completer<TimeTrackReply>();
    _timeTrackings
        .deleteTrack(id: request.id, trackId: request.trackId)
        .then((timeTrack) => timeTrack.toReply())
        .then((value) => completer.complete(value))
        .catchError((onError) {
      if (onError is DbException) {
        call.sendTrailers(
            status: StatusCode.notFound, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });
    return completer.future;
  }
}
