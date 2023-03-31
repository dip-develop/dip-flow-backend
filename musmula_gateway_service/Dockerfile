FROM dart:stable AS protobuf

ARG TARGETARCH

RUN if [ "$TARGETARCH" = "amd64" ]; then  \
    curl -L -o protoc.zip 'https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-x86_64.zip' ;  \
    fi

RUN if [ "$TARGETARCH" = "arm64" ]; then  \
    curl -L -o protoc.zip 'https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-aarch_64.zip' ;  \
    fi

RUN unzip protoc.zip -d /protoc

FROM dart:stable AS build

COPY --from=protobuf /protoc/bin/protoc /bin/
COPY --from=protobuf /protoc/include /usr/local/include
COPY --from=protobuf /protoc/readme.txt /protoc-readme.txt

WORKDIR /app

ENV PATH="/root/.pub-cache/bin:$PATH"
RUN dart pub global activate protoc_plugin

COPY musmula_gateway_service/ ./
RUN dart pub get
RUN mkdir lib/src/generated/
COPY protos ./protos
RUN protoc --dart_out=grpc:lib/src/generated -Iprotos \
    protos/gate_service.proto \
    protos/auth_models.proto \
    protos/auth_service.proto \
    protos/time_tracking_models.proto \
    protos/time_tracking_service.proto \
    protos/google/api/annotations.proto \
    protos/google/api/http.proto \
    protos/google/protobuf/descriptor.proto \
    protos/google/protobuf/empty.proto \
    protos/google/protobuf/timestamp.proto
RUN dart run build_runner build -d
RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
CMD ["/app/bin/server"]