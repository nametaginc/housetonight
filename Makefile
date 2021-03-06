# Copyright 2022 Nametag Inc.
#
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

#
# For the HOUSETONIGHT_DNS_NAME and NAMETAG_SERVER_DNS_NAME do not include the
# https:// or http:// part, only the domain name is needed
#
HOUSETONIGHT_DNS_NAME ?= A_DOMAIN_NAME_or_an_ngrok.io_HOST_goes_here
NAMETAG_SERVER_DNS_NAME ?= nametag.co
NAMETAG_CLIENT_ID ?= CLIENT_ID_goes_here
NAMETAG_CLIENT_SECRET ?= CLIENT_SECRET_goes_here

.PHONY: build
build:
	[ ! -d build ] || rm -rf build
	mkdir build build/images
	cp images/*.jpg build/images
	cp main.css build/main.css
	cat index.tmpl.html |\
		sed 's/@@NAMETAG_SERVER@@/https:\/\/$(NAMETAG_SERVER_DNS_NAME)/' |\
		sed 's/@@NAMETAG_CLIENT_ID@@/$(NAMETAG_CLIENT_ID)/' |\
		sed 's/@@URL@@/https:\/\/$(HOUSETONIGHT_DNS_NAME)/' |\
		sed 's/@@PKCE@@/true/' |\
		cat > build/index.html

.PHONY: build-nopkce
build-nopkce:
	[ ! -d build-nopkce ] || rm -rf build-nopkce
	mkdir build-nopkce build-nopkce/images
	cp images/*.jpg build-nopkce/images
	cp main.css build-nopkce/main.css
	cat index.html |\
		sed 's/@@NAMETAG_SERVER@@/https:\/\/$(NAMETAG_SERVER_DNS_NAME)/' |\
		sed 's/@@NAMETAG_CLIENT_ID@@/$(NAMETAG_CLIENT_ID)/' |\
		sed 's/@@URL@@/https:\/\/$(HOUSETONIGHT_DNS_NAME)/' |\
		sed 's/@@PKCE@@/false/' |\
		cat > build-nopkce/index.html
	go build -o ./build-nopkce/server nopkce.go

.PHONY: run-nopkce
run-nopkce: build-nopkce
	NAMETAG_CLIENT_ID=$(NAMETAG_CLIENT_ID) \
	NAMETAG_CLIENT_SECRET=$(NAMETAG_CLIENT_SECRET) \
	NAMETAG_SERVER=https://$(NAMETAG_SERVER_DNS_NAME) \
	HOUSETONIGHT_URL=https://$(HOUSETONIGHT_DNS_NAME) \
		./build-nopkce/server
