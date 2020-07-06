INSTALL_PATH=/usr/local

build:
	install gacme $(INSTALL_PATH)/bin
	install parseGeminiResponse.awk $(INSTALL_PATH)/lib
	install getMeta.awk $(INSTALL_PATH)/lib

install: build

uninstall:
	rm $(INSTALL_PATH)/bin/gacme
	rm $(INSTALL_PATH)/lib/parseGeminiResponse.awk
	rm $(INSTALL_PATH)/lib/getMeta.awk