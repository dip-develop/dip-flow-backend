import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../domain/exceptions/exceptions.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/base_models.pb.dart';

import '../generated/google/protobuf/empty.pb.dart';
import '../generated/google/protobuf/timestamp.pb.dart';
import '../generated/time_tracking_models.pb.dart';
import '../generated/time_tracking_service.pbgrpc.dart';

@singleton
class TimeTrackingService extends TimeTrackingServiceBase {
  final _log = Logger('TimeTrackingService');
  final TimeTrackingsUseCase _timeTrackings;

  TimeTrackingService(this._timeTrackings);

  @override
  Future<TimeTrackingReply> getTimeTracking(
    ServiceCall call,
    IdRequest request,
  ) {
    _log.finer('Call "getTimeTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<TimeTrackingReply>();
    _timeTrackings
        .getTimeTracking(request.id)
        .then(
          (timeTrack) => TimeTrackingReply(
            id: timeTrack.id,
            userId: timeTrack.userId,
            taskId: timeTrack.taskId,
            title: timeTrack.title,
            description: timeTrack.description,
            tracks: timeTrack.tracks.map(
              (p0) => TrackReply(
                id: p0.id,
                start: Timestamp.fromDateTime(p0.start),
                end: p0.end != null ? Timestamp.fromDateTime(p0.end!) : null,
              ),
            ),
          ),
        )
        .then((value) => completer.complete(value))
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });
    return completer.future;
  }

  @override
  Future<TimeTrackingsReply> getTimeTrackings(
    ServiceCall call,
    FilterRequest request,
  ) {
    _log.finer('Call "getTimeTracks"');
    _log.finest(request.toDebugString());
    final completer = Completer<TimeTrackingsReply>();
    _timeTrackings
        .getTimeTrackings(
          userId: request.userId,
          offset:
              request.pagination.hasOffset() ? request.pagination.offset : null,
          limit:
              request.pagination.hasLimit() ? request.pagination.limit : null,
          start:
              request.dateRange.hasStart()
                  ? request.dateRange.start.toDateTime()
                  : null,
          end:
              request.dateRange.hasEnd()
                  ? request.dateRange.end.toDateTime()
                  : null,
          search: request.search.hasSearch() ? request.search.search : null,
        )
        .then(
          (timeTracks) => TimeTrackingsReply(
            count: timeTracks.count,
            limit: timeTracks.limit,
            offset: timeTracks.offset,
            timeTracks: timeTracks.items.map(
              (timeTrack) => TimeTrackingReply(
                id: timeTrack.id,
                userId: timeTrack.userId,
                taskId: timeTrack.taskId,
                title: timeTrack.title,
                description: timeTrack.description,
                tracks: timeTrack.tracks.map(
                  (p0) => TrackReply(
                    id: p0.id,
                    start: Timestamp.fromDateTime(p0.start),
                    end:
                        p0.end != null ? Timestamp.fromDateTime(p0.end!) : null,
                  ),
                ),
              ),
            ),
          ),
        )
        .then((value) => completer.complete(value))
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });

    return completer.future;
  }

  @override
  Future<TimeTrackingReply> addTimeTracking(
    ServiceCall call,
    AddTimeTrackingRequest request,
  ) {
    _log.finer('Call "addTimeTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<TimeTrackingReply>();
    _timeTrackings
        .addTimeTracking(
          userId: request.userId,
          taskId: request.taskId,
          title: request.title,
          description: request.description,
        )
        .then((timeTrack) {
          completer.complete(
            TimeTrackingReply(
              id: timeTrack.id,
              userId: timeTrack.userId,
              taskId: timeTrack.taskId,
              title: timeTrack.title,
              description: timeTrack.description,
              tracks: timeTrack.tracks.map(
                (p0) => TrackReply(
                  id: p0.id,
                  start: Timestamp.fromDateTime(p0.start),
                  end: p0.end != null ? Timestamp.fromDateTime(p0.end!) : null,
                ),
              ),
            ),
          );
        })
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });

    return completer.future;
  }

  @override
  Future<TimeTrackingReply> updateTimeTracking(
    ServiceCall call,
    UpdateTimeTrackingRequest request,
  ) {
    _log.finer('Call "updateTimeTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<TimeTrackingReply>();
    _timeTrackings
        .updateTimeTracking(
          id: request.id,
          taskId: request.taskId,
          title: request.title,
          description: request.description,
        )
        .then((timeTrack) {
          completer.complete(timeTrack.toReply());
        })
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });

    return completer.future;
  }

  @override
  Future<Empty> deleteTimeTracking(ServiceCall call, IdRequest request) {
    _log.finer('Call "deleteTimeTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<Empty>();
    _timeTrackings
        .deleteTimeTracking(request.id)
        .then((_) => completer.complete(Empty()))
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });
    return completer.future;
  }

  @override
  Future<TracksReply> getTracks(ServiceCall call, FilterRequest request) {
    _log.finer('Call "getTracks"');
    _log.finest(request.toDebugString());
    final completer = Completer<TracksReply>();
    // TODO: implement getTracks
    return completer.future;
  }

  @override
  Future<TimeTrackingReply> startTrack(ServiceCall call, IdRequest request) {
    _log.finer('Call "startTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<TimeTrackingReply>();
    _timeTrackings
        .startTimeTracking(request.id)
        .then((timeTrack) => timeTrack.toReply())
        .then((value) => completer.complete(value))
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });
    return completer.future;
  }

  @override
  Future<TimeTrackingReply> stopTrack(ServiceCall call, IdRequest request) {
    _log.finer('Call "stopTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<TimeTrackingReply>();
    _timeTrackings
        .stopTimeTracking(request.id)
        .then((timeTrack) => timeTrack.toReply())
        .then((value) => completer.complete(value))
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });
    return completer.future;
  }

  @override
  Future<Empty> deleteTrack(ServiceCall call, IdRequest request) {
    _log.finer('Call "deleteTrack"');
    _log.finest(request.toDebugString());
    final completer = Completer<Empty>();
    _timeTrackings
        .deleteTrack(request.id)
        .then((_) => completer.complete(Empty()))
        .catchError((onError) {
          if (onError is DbException) {
            call.sendTrailers(
              status: StatusCode.notFound,
              message: onError.message,
            );
          } else {
            call.sendTrailers(status: StatusCode.unknown);
          }
          completer.completeError(onError);
        });
    return completer.future;
  }
}
