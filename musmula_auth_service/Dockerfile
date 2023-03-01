FROM robojones/protoc-dart:20.0.1 AS build

WORKDIR /app

# RUN /bin/sh -c set -eux && \
#     case "$(dpkg --print-architecture)" in \
#     amd64) \
#     SDK_ARCH="x86_64";; \
#     x86) \
#     SDK_ARCH="x86_32";; \
#     arm64) \
#     SDK_ARCH="aarch_64";; \
#     esac \
#     VERSION = "22.0" \
#     URL = "https://github.com/protocolbuffers/protobuf/releases/download/v$VERSION/protoc-$VERSION-linux-$SDK_ARCH.zip" \
#     echo "SDK: $URL" >> setup.log 
#    # curl -fLO "$URL" \

# ENV PROTOC_VERSION=22.0
# ENV PROTOC_ARCH=x86_64
# ENV PROTOC_ZIP=protoc-${PROTOC_VERSION}-linux-${PROTOC_ARCH}.zip
# RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/${PROTOC_ZIP}

# RUN unzip -o ${PROTOC_ZIP} -d ./proto 
# RUN chmod 755 -R ./proto/bin
# ENV BASE=/usr/local
# RUN cp ./proto/bin/protoc ${BASE}/bin
# RUN cp -R ./proto/include/* ${BASE}/include 

# RUN apt-get update \
#  && DEBIAN_FRONTEND=noninteractive \
#     apt-get install --no-install-recommends --assume-yes \
#       protobuf-compiler

#ENV PATH="$PATH:~/.pub-cache/bin"
#RUN dart pub global activate protoc_plugin
#RUN chmod 755 -R $HOME/.pub-cache/bin/protoc-gen-dart

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN mkdir lib/src/generated/
RUN protoc --dart_out=grpc:lib/src/generated -Iprotos protos/auth.proto
RUN dart pub run build_runner build -d

RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

EXPOSE 8080
CMD ["/app/bin/server"]