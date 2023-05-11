import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../generated/gate_models.pb.dart';
import '../generated/gate_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/user_models.pb.dart';
import '../generated/user_service.pbgrpc.dart';

@singleton
class ProfileService extends ProfileGateServiceBase {
  final UserServiceClient _userClient;

  ProfileService(this._userClient);

  @override
  Future<ProfileReply> getProfile(ServiceCall call, Empty request) =>
      _userClient
          .getUser(request, options: CallOptions(metadata: call.clientMetadata))
          .then((p0) => ProfileReply(
              name: p0.name,
              image: p0.image,
              price: p0.price,
              workDays: p0.workDays));

  @override
  Future<Empty> updateProfile(ServiceCall call, UserRequest request) =>
      _userClient.updateUser(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<Empty> deleteProfile(ServiceCall call, Empty request) => _userClient
      .deleteUser(request, options: CallOptions(metadata: call.clientMetadata));
}
