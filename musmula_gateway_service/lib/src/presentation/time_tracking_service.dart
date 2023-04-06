import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../generated/auth_service.pbgrpc.dart';
import '../generated/base_models.pb.dart';
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
  Future<TimeTrackReply> getTimeTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.getTimeTrack(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTracksReply> getTimeTracks(
          ServiceCall call, PaginationRequest request) =>
      _authClient
          .getUser(Empty(), options: CallOptions(metadata: call.clientMetadata))
          .then((user) => _timeTrackingClient.getTimeTracks(GetTimeTrackRequest(
              userId: user.id, offset: request.offset, limit: request.limit)));

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
  Future<TimeTrackReply> updateTimeTrack(
          ServiceCall call, UpdateTimeTrackRequest request) =>
      _timeTrackingClient.updateTimeTrack(
          UpdateTimeTrackRequest(
            id: request.id,
            task: request.task,
            title: request.title,
            description: request.description,
          ),
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<Empty> deleteTimeTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.deleteTimeTrack(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTrackReply> startTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.startTrack(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTrackReply> stopTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.stopTrack(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTrackReply> deleteTrack(
          ServiceCall call, DeleteTrackRequest request) =>
      _timeTrackingClient.deleteTrack(request,
          options: CallOptions(metadata: call.clientMetadata));
}
