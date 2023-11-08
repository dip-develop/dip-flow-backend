FROM dart:stable AS protobuf

ARG TARGETARCH

RUN if [ "$TARGETARCH" = "amd64" ]; then  \
    curl -L -o protoc.zip 'https://github.com/protocolbuffers/protobuf/releases/download/v25.0/protoc-25.0-linux-x86_64.zip' ;  \
    fi

RUN if [ "$TARGETARCH" = "arm64" ]; then  \
    curl -L -o protoc.zip 'https://github.com/protocolbuffers/protobuf/releases/download/v25.0/protoc-25.0-linux-aarch_64.zip' ;  \
    fi

RUN unzip protoc.zip -d /protoc

FROM dart:stable AS build

COPY --from=protobuf /protoc/bin/protoc /bin/
COPY --from=protobuf /protoc/include /usr/local/include
COPY --from=protobuf /protoc/readme.txt /protoc-readme.txt

WORKDIR /app

ENV PATH="/root/.pub-cache/bin:$PATH"

COPY activity_service/ ./
RUN dart pub get
RUN dart pub upgrade
RUN chmod +x generate.sh
RUN ./generate.sh
RUN dart compile exe bin/server.dart -o bin/server

FROM ubuntu:latest
WORKDIR "/app"
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/lib/libobjectbox.so /app/lib/
CMD ["/app/bin/server"]