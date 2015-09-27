all:
	DreamMaker dmut.dme
clean:
	rm -f dmut.dmb dmut.rsc
run:
	/usr/share/byond/bin/byondexec /usr/share/byond/bin/DreamDaemon dmut.dmb 7022 -webclient
