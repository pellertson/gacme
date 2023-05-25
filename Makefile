INSTALL_PATH=/usr/local

build:
	mkdir -p $(INSTALL_PATH)/{bin,lib}
	install gacme $(INSTALL_PATH)/bin
	install parseGeminiResponse.awk $(INSTALL_PATH)/lib
	install getMeta.awk $(INSTALL_PATH)/lib
	sed -i 's|INSTALL_PATH|$(INSTALL_PATH)|' $(INSTALL_PATH)/bin/gacme
	chmod +x $(INSTALL_PATH)/bin/gacme

install: build

uninstall:
	rm $(INSTALL_PATH)/bin/gacme
	rm $(INSTALL_PATH)/lib/parseGeminiResponse.awk
	rm $(INSTALL_PATH)/lib/getMeta.awk
