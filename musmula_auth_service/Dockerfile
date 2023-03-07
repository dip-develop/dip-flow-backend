FROM robojones/protoc-dart:20.0.1 AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN mkdir lib/src/generated/
RUN protoc --dart_out=grpc:lib/src/generated -Iprotos protos/auth.proto
RUN dart run build_runner build -d
RUN dart compile exe bin/server.dart -o bin/server

FROM ubuntu:latest
COPY --from=build /app/bin/server /app/bin/

#EXPOSE 8080
CMD ["/app/bin/server"]