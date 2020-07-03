INSTALL_PATH=/usr/local

build:
	cp gacme $(INSTALL_PATH)/bin
	cp parseGeminiResponse.awk $(INSTALL_PATH)/lib
	cp getMeta.awk $(INSTALL_PATH)/lib

install: build

uninstall:
	rm $(INSTALL_PATH)/bin/gacme
	rm $(INSTALL_PATH)/bin/parseGeminiResponse.awk
	rm $(INSTALL_PATH)/bin/getMeta.awk