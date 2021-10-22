GO_VERSION="1.17.2"
GO_INSTALL_PATH="/usr/local"

FRP_VERSION="0.37.1"
FRP_INSTALL_PATH="/usr/local"

PROTOC_VERSION="3.18.1"

.PHONY: clean
# 清除 golang 旧版本
clean:
	@echo "正在清理Go环境" && \
	sudo -v && \
	rm -rf $(GO_INSTALL_PATH)/go && \
	rm -f /usr/local/bin/go && \
	rm -f /usr/bin/go

.PHONY: go
# 安装 golang
go: clean
	@echo "安装 golang:$(GO_VERSION)" && \
	mkdir -p third && cd third && \
	wget https://golang.google.cn/dl/go$(GO_VERSION).linux-amd64.tar.gz && \
	tar xf go$(GO_VERSION).linux-amd64.tar.gz && \
	sudo mv go/ $(GO_INSTALL_PATH) && \
	sudo ln -s $(GO_INSTALL_PATH)/go/bin/go /usr/local/bin/go && \
	cd .. && \
	rm -rf third/ && \
	go version && \
	export GO111MODULE=on && \
	export GOPROXY=https://goproxy.io; \


.PHONY: protoc
# 安装 protobuf 代码生成工具 protoc
protoc:
	@echo "安装 protobuf 代码生成工具 protoc" && \
	mkdir -p third && cd third && \
	wget https://github.com/google/protobuf/releases/download/v$(PROTOC_VERSION)/protobuf-cpp-$(PROTOC_VERSION).tar.gz && \
	tar -xf protobuf-cpp-$(PROTOC_VERSION).tar.gz && \
	cd protobuf-$(PROTOC_VERSION) && \
	./configure --prefix=`pwd`/../protobuf && \
	make -j8 && \
	make install && \
	cd ../.. && \
	rm -rf third && \
	protoc --version; \
	echo "安装 protobuf golang 插件 protoc-gen-go" && \
	go get -u github.com/golang/protobuf/{proto,protoc-gen-go}

.PHONY: frp
# 安装 frp 内网穿透工具
frp:
	@echo "安装 frp 内网穿透工具" && \
	mkdir -p third && cd third && \
	wget https://github.com/fatedier/frp/releases/download/v$(FRP_VERSION)/frp_$(FRP_VERSION)_linux_amd64.tar.gz && \
	tar xf frp_$(FRP_VERSION)_linux_amd64.tar.gz && \
	sudo mv frp_$(FRP_VERSION)_linux_amd64/ $(FRP_INSTALL_PATH)/frp && \
	cd .. && \
	rm -rf third && \
	cd $(FRP_INSTALL_PATH)/frp

help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help