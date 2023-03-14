AUTH_GENERATED=musmula_auth_service/lib/src/generated

generate:
	@echo "Generating Proto files..."
	@mkdir -p $(AUTH_GENERATED)
	protoc --plugin=protoc-gen-dart.bat --dart_out=grpc:$(AUTH_GENERATED) -Iprotos musmula_auth_service/protos/auth.proto