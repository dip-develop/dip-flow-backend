FROM dart:stable AS protobuf
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then  \
    curl -L -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v25.1/protoc-25.1-linux-x86_64.zip" ;  \
    else \
    curl -L -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v25.1/protoc-25.1-linux-aarch_64.zip" ;  \
    fi
RUN unzip protoc.zip -d /protoc

FROM dart:stable AS build
COPY --from=protobuf /protoc/bin/protoc /bin/
COPY --from=protobuf /protoc/include /usr/local/include
COPY --from=protobuf /protoc/readme.txt /protoc-readme.txt
WORKDIR /app
ENV PATH="/root/.pub-cache/bin:$PATH"
#COPY .  ./
COPY packages/activity_service/ ./
RUN chmod +x generate.sh
RUN sh ./generate.sh
RUN dart compile exe "bin/server.dart" -o "bin/server"

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
CMD ["/app/bin/server"]