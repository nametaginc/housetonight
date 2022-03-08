HOUSETONIGHT_DNS_NAME := "your-example-site.example.com"
NAMETAG_CLIENT_ID := "Your-ClientID-from-console.nametag.co-here"
NAMETAG_SERVER_DNS_NAME := "nametag.co"

NETLIFY := netlify
ifeq (, $(shell command -v "$(NETLIFY)"))
	NETLIFY_ERR = $(error install the Netlify CLI with e.g. npm install netlify-cli -g))
endif

.PHONY: build
build:
	[ ! -d build ] || rm -rf build
	mkdir build
	cp -r images main.css build
	cat index.html |\
		sed 's/@@NAMETAG_SERVER@@/https:\/\/$(NAMETAG_SERVER_DNS_NAME)/' |\
		sed 's/@@NAMETAG_CLIENT_ID@@/$(NAMETAG_CLIENT_ID)/' |\
		sed 's/@@URL@@/https:\/\/$(HOUSETONIGHT_DNS_NAME)/' |\
		cat > build/index.html

.PHONY: deploy
deploy: build ; $(NETLIFY_ERR)
	$(NETLIFY) deploy --prod --site "$(HOUSETONIGHT_DNS_NAME)" --dir build

.PHONY: destroy
destroy: ; $(NETLIFY_ERR)
	$(NETLIFY) sites:delete $(HOUSETONIGHT_DNS_NAME)
