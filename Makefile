PREFIX ?= /usr/local

INSTALL_FILE    = install -m644 -D
INSTALL_DIR     = install -m755 -d
INSTALL_PROGRAM = install -m755 -D

CP    = cp -rf
RM    = rm -rf
LN    = ln -s
GZIP  = gzip -f9
RMDIR = rmdir
QMAKE = qmake
MAKE  = make

fc_MAKEFILE = framecounter.mk
INFILES = hybrid hybrid-qt46 hybrid-qt5 run-hybrid


all:
	$(foreach FILE,$(INFILES),sed -e 's@___PREFIX___@$(PREFIX)@g' $(FILE).in > $(FILE) ; )
	$(QMAKE) -o $(fc_MAKEFILE)
	$(MAKE)  -f $(fc_MAKEFILE)

install: install-hybrid install-hook

install-hybrid:
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/share/applications
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/share/hybrid-common
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/share/icons/hicolor
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/share/man/man1
	$(INSTALL_PROGRAM) framecounter      $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_PROGRAM) hybrid            $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_PROGRAM) hybrid-qt46       $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_PROGRAM) hybrid-qt5        $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_PROGRAM) install-hybrid.sh $(DESTDIR)$(PREFIX)/share/hybrid-common
	$(INSTALL_FILE) run-hybrid          $(DESTDIR)$(PREFIX)/share/hybrid-common
	$(INSTALL_FILE) hybrid.desktop      $(DESTDIR)$(PREFIX)/share/applications
	$(INSTALL_FILE) hybrid-qt46.desktop $(DESTDIR)$(PREFIX)/share/applications
	$(INSTALL_FILE) hybrid-qt5.desktop  $(DESTDIR)$(PREFIX)/share/applications
	$(INSTALL_FILE) hybrid-encoder.1    $(DESTDIR)$(PREFIX)/share/man/man1
	$(CP) icons/* $(DESTDIR)$(PREFIX)/share/icons/hicolor

install-hook:
	$(GZIP) $(DESTDIR)$(PREFIX)/share/man/man1/hybrid-encoder.1
	$(LN) hybrid-encoder.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/hybrid.1.gz
	$(LN) hybrid-encoder.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/hybrid-qt46.1.gz
	$(LN) hybrid-encoder.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/hybrid-qt5.1.gz

uninstall:
	cd $(DESTDIR)$(PREFIX)/bin && $(RM) framecounter hybrid hybrid-qt46 hybrid-qt5
	cd $(DESTDIR)$(PREFIX)/share/applications && \
		$(RM) hybrid.desktop hybrid-qt46.desktop hybrid-qt5.desktop
	cd $(DESTDIR)$(PREFIX)/share/man/man1 && \
		$(RM) hybrid.1* hybrid-qt46.1* hybrid-qt5.1* hybrid-encoder.1*
	$(RM) $(DESTDIR)$(PREFIX)/share/hybrid-common
	$(RMDIR) $(DESTDIR)$(PREFIX)/bin
	$(RMDIR) $(DESTDIR)$(PREFIX)/share/applications
	$(RMDIR) $(DESTDIR)$(PREFIX)/share/hybrid-common
	$(RMDIR) $(DESTDIR)$(PREFIX)/share/icons
	$(RMDIR) $(DESTDIR)$(PREFIX)/share/man/man1
	$(RMDIR) $(DESTDIR)$(PREFIX)/share/man
	$(RMDIR) $(DESTDIR)$(PREFIX)/share

clean:
	[ ! -f $(fc_MAKEFILE) ] || $(MAKE) -f $(fc_MAKEFILE) clean
	rm -f $(INFILES)

distclean: clean
	[ ! -f $(fc_MAKEFILE) ] || $(MAKE) -f $(fc_MAKEFILE) distclean
