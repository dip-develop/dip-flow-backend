FROM ubuntu:latest AS build
WORKDIR /app
RUN apt update && apt install protobuf-compiler dart -y 
RUN dart pub global activate protoc_plugin
COPY musmula_time_tracking_service/ ./
RUN dart pub get
RUN mkdir lib/src/generated/
COPY protos ./protos
RUN protoc --dart_out=grpc:lib/src/generated -Iprotos \
    protos/time_tracking_service.proto
RUN dart run build_runner build -d
RUN dart compile exe bin/server.dart -o bin/server
FROM ubuntu:latest
COPY --from=build /app/bin/server /app/bin/
CMD ["/app/bin/server"]