import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../generated/auth_service.pbgrpc.dart';
import '../generated/gate_models.pb.dart' as gate;
import '../generated/gate_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/time_tracking_models.pb.dart';
import '../generated/time_tracking_service.pbgrpc.dart';

@Singleton()
class TimeTrackingService extends TimeTrackingGateServiceBase {
  final TimeTrackingServiceClient _timeTrackingClient;
  final AuthServiceClient _authClient;

  TimeTrackingService(this._timeTrackingClient, this._authClient);

  @override
  Future<TimeTrackReply> getTimeTrack(
          ServiceCall call, GetTimeTrackRequest request) =>
      _timeTrackingClient.getTimeTrack(GetTimeTrackRequest(id: request.id),
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTracksReply> getTimeTracks(ServiceCall call, Empty request) =>
      _authClient
          .getUser(request, options: CallOptions(metadata: call.clientMetadata))
          .then((user) => _timeTrackingClient
              .getTimeTracks(GetTimeTracksRequest(userId: user.id)));

  @override
  Future<TimeTrackReply> addTimeTrack(
          ServiceCall call, gate.AddTimeTrackRequest request) =>
      _authClient
          .getUser(Empty(), options: CallOptions(metadata: call.clientMetadata))
          .then((user) => _timeTrackingClient.addTimeTrack(AddTimeTrackRequest(
              userId: user.id,
              task: request.task,
              title: request.title,
              description: request.description)));

  @override
  Future<Empty> deleteTimeTrack(
          ServiceCall call, DeleteTimeTrackRequest request) =>
      _timeTrackingClient.deleteTimeTrack(
          DeleteTimeTrackRequest(id: request.id),
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTrackReply> updateTimeTrack(
          ServiceCall call, UpdateTimeTrackRequest request) =>
      _timeTrackingClient.updateTimeTrack(
          UpdateTimeTrackRequest(
              id: request.id,
              task: request.task,
              title: request.task,
              description: request.description,
              tracks: request.tracks),
          options: CallOptions(metadata: call.clientMetadata));
}
