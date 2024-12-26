import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../generated/base_models.pb.dart';
import '../generated/gate_models.pb.dart' as gate;
import '../generated/gate_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/time_tracking_models.pb.dart';
import '../generated/time_tracking_service.pbgrpc.dart';
import '../generated/user_service.pbgrpc.dart';

@singleton
class TimeTrackingService extends TimeTrackingGateServiceBase {
  final TimeTrackingServiceClient _timeTrackingClient;
  final UserServiceClient _userClient;

  TimeTrackingService(this._timeTrackingClient, this._userClient);

  @override
  Future<TimeTrackingReply> getTimeTracking(
          ServiceCall call, IdRequest request) =>
      _timeTrackingClient.getTimeTracking(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTrackingsReply> getTimeTrackings(
          ServiceCall call, gate.FilterRequest request) =>
      _userClient
          .getUser(Empty(), options: CallOptions(metadata: call.clientMetadata))
          .then((user) => _timeTrackingClient.getTimeTrackings(FilterRequest(
              userId: user.id,
              pagination: request.pagination,
              dateRange: request.dateRange,
              search: request.search)));

  @override
  Future<TimeTrackingReply> addTimeTracking(
          ServiceCall call, gate.AddTimeTrackingRequest request) =>
      _userClient
          .getUser(Empty(), options: CallOptions(metadata: call.clientMetadata))
          .then((user) => _timeTrackingClient.addTimeTracking(
              AddTimeTrackingRequest(
                  userId: user.id,
                  taskId: request.taskId,
                  title: request.title,
                  description: request.description)));

  @override
  Future<TimeTrackingReply> updateTimeTracking(
          ServiceCall call, UpdateTimeTrackingRequest request) =>
      _timeTrackingClient.updateTimeTracking(
          UpdateTimeTrackingRequest(
            id: request.id,
            taskId: request.taskId,
            title: request.title,
            description: request.description,
          ),
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<Empty> deleteTimeTracking(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.deleteTimeTracking(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TracksReply> getTracks(ServiceCall call, gate.FilterRequest request) =>
      _userClient
          .getUser(Empty(), options: CallOptions(metadata: call.clientMetadata))
          .then((user) => _timeTrackingClient.getTracks(
              FilterRequest(
                  userId: user.id,
                  dateRange: request.dateRange,
                  pagination: request.pagination,
                  search: request.search),
              options: CallOptions(metadata: call.clientMetadata)));

  @override
  Future<TimeTrackingReply> startTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.startTrack(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<TimeTrackingReply> stopTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.stopTrack(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<Empty> deleteTrack(ServiceCall call, IdRequest request) =>
      _timeTrackingClient.deleteTrack(request,
          options: CallOptions(metadata: call.clientMetadata));
}
