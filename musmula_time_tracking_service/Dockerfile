FROM dart:stable AS protobuf

ARG TARGETARCH

RUN echo $TARGETARCH;

RUN if [ "$TARGETARCH" = "amd64" ]; then  \
    curl -L -o protoc.zip 'https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-x86_64.zip' ;  \
    fi

RUN if [ "$TARGETARCH" = "arm64" ]; then  \
    curl -L -o protoc.zip 'https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-aarch64.zip' ;  \
    fi

RUN unzip protoc.zip -d /protoc

FROM dart:stable AS build

COPY --from=protobuf /protoc/bin/protoc /bin/
COPY --from=protobuf /protoc/include /usr/local/include
COPY --from=protobuf /protoc/readme.txt /protoc-readme.txt

WORKDIR /app

ENV PATH="/root/.pub-cache/bin:$PATH"
RUN dart pub global activate protoc_plugin

COPY musmula_time_tracking_service/ ./
RUN dart pub get
RUN mkdir lib/src/generated/
COPY protos ./protos
RUN protoc --dart_out=grpc:lib/src/generated -Iprotos \
    protos/time_tracking_service.proto
RUN bash -c 'bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh) --sync --quiet'
RUN dart run build_runner build -d
RUN dart compile exe bin/server.dart -o bin/server

FROM ubuntu:latest
WORKDIR "/app"
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/lib/libobjectbox.so /app/lib/
CMD ["/app/bin/server"]