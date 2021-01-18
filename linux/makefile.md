# MakeFile

## Golang

```makefile
export PATH:=${PATH}:${GOPATH}/bin:$(shell pwd)/third/go/bin:$(shell pwd)/third/protobuf/bin:$(shell pwd)/third/cloc-1.76

.PHONY: golang
golang:
    @hash go 2>/dev/null || { \
        echo "安装 golang 环境 go1.14" && \
        mkdir -p third && cd third && \
        wget https://golang.google.cn/dl/go1.15.6.linux-amd64.tar.gz && \
        tar -xzvf go1.14.linux-amd64.tar.gz && \
        sudo mv go/ /usr/local/ && \
        sudo ln -s /usr/local/go/bin/go /usr/local/bin/go && \
        cd .. && \
        rm -rf third/ && \
        go version && \
        export GO111MODULE=on && \
        export GOPROXY=https://goproxy.io; \
    }

.PHONY: protoc
protoc: golang
    @hash protoc 2>/dev/null || { \
        echo "安装 protobuf 代码生成工具 protoc" && \
        mkdir -p third && cd third && \
        wget https://github.com/google/protobuf/releases/download/v3.2.0/protobuf-cpp-3.2.0.tar.gz && \
        tar -xzvf protobuf-cpp-3.2.0.tar.gz && \
        cd protobuf-3.2.0 && \
        ./configure --prefix=`pwd`/../protobuf && \
        make -j8 && \
        make install && \
        cd ../.. && \
        protoc --version; \
    }
    @hash protoc-gen-go 2>/dev/null || { \
        echo "安装 protobuf golang 插件 protoc-gen-go" && \
        go get -u github.com/golang/protobuf/{proto,protoc-gen-go}; \
    }

```