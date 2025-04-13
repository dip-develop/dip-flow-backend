# Установите версии в аргументы сборки
ARG DART_VERSION=stable
ARG PROTOBUF_VERSION=29.2

# Используем базовый образ Dart
FROM dart:${DART_VERSION} AS protobuf
ARG TARGETARCH
ARG PROTOBUF_VERSION
RUN echo "TARGETARCH is $TARGETARCH" \
    && echo "PROTOBUF_VERSION is $PROTOBUF_VERSION" \
    && if [ "$TARGETARCH" = "amd64" ]; then  \
    curl -L -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip" ;  \
    else \
    curl -L -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-aarch_64.zip" ;  \
    fi \
    && unzip protoc.zip -d /protoc \
    && rm protoc.zip

FROM dart:${DART_VERSION} AS build
COPY --from=protobuf /protoc/bin/protoc /bin/
COPY --from=protobuf /protoc/include /usr/local/include

WORKDIR /app
ENV PATH="/root/.pub-cache/bin:$PATH"
COPY . ./

RUN dart pub get \
    && dart pub upgrade \
    && dart pub global activate protoc_plugin \
    && mkdir -p lib/src/generated \
    && cp -r /usr/local/include/google protos/ \
    && protoc --proto_path=protos/ --dart_out=grpc:lib/src/generated -Iprotos \
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
        google/protobuf/timestamp.proto \
    && dart run build_runner build -d \
    && dart compile exe "bin/server.dart" -o "bin/server"

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
CMD ["/app/bin/server"]
