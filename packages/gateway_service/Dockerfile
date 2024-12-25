FROM dart:stable AS protobuf
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then  \
    curl -L -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v29.2/protoc-29.2-linux-x86_64.zip" ;  \
    else \
    curl -L -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v29.2/protoc-29.2-linux-aarch_64.zip" ;  \
    fi
RUN unzip protoc.zip -d /protoc

FROM dart:stable AS build
COPY --from=protobuf /protoc/bin/protoc /bin/
COPY --from=protobuf /protoc/include /usr/local/include
COPY --from=protobuf /protoc/readme.txt /protoc-readme.txt

WORKDIR /app
ENV PATH="/root/.pub-cache/bin:$PATH"
#COPY .  ./
COPY packages/gateway_service/ ./

RUN dart pub get
RUN dart pub upgrade
RUN dart pub global activate protoc_plugin

RUN mkdir -p lib/src/generated
RUN cp -r /usr/local/include/google protos/
RUN protoc --proto_path=protos/ --dart_out=grpc:lib/src/generated -Iprotos \
    base_models.proto \
    gate_models.proto \
    gate_service.proto \
    auth_models.proto \
    auth_service.proto \
    user_models.proto \
    user_service.proto \
    project_models.proto \
    project_service.proto \
    task_models.proto \
    task_service.proto \
    time_tracking_models.proto \
    time_tracking_service.proto \
    google/protobuf/empty.proto \
    google/protobuf/timestamp.proto

RUN dart run build_runner build -d
RUN dart compile exe "bin/server.dart" -o "bin/server"

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
CMD ["/app/bin/server"]