dist: zips dmgs

zips: clean-zips
	for BUNDLE in *.bundle ; do \
	    BASENAME=$$(basename "$${BUNDLE}" .bundle) ; \
	    zip -r -9 "$${BASENAME}.zip" "$${BUNDLE}" ; \
	done

dmgs: download-create-dmg clean-dmgs
	set -ex ; \
	for BUNDLE in *.bundle ; do \
	    rm -Rf .dmg ;\
	    mkdir .dmg ; \
	    cp -a "$${BUNDLE}" .dmg ; \
	    ln -s /Library/"Keyboard Layouts" .dmg ; \
	    BASENAME=$$(basename "$${BUNDLE}" .bundle) ; \
	    (cd .create-dmg && ./create-dmg \
	        --volicon "$$(find "../$${BUNDLE}" -name "*.icns")" \
	        --volname "$${BASENAME}" \
	        --background "../etc/dmg_background.png" \
	        --window-size 600 400 \
	        --icon-size 100 \
	        --icon "$${BUNDLE}" 120 220 \
	        --hide-extension "$${BUNDLE}" \
	        --icon "Keyboard Layouts" 480 220 \
	        ../"$${BASENAME}.dmg" \
	        ../.dmg/ ; \
	    ) ; \
	    rm -rf .dmg ; \
	done
	        
download-create-dmg:
	set -ex ; \
	mkdir -p .create-dmg/support ; \
	touch .create-dmg/.this-is-the-create-dmg-repo ; \
	for FILE in create-dmg support/template.applescript support/eula-resources-template.xml; do \
	    if [ ! -f .create-dmg/$${FILE} ] ; then \
	        curl https://raw.githubusercontent.com/create-dmg/create-dmg/v1.2.1/$${FILE} --output .create-dmg/$${FILE} ; \
	    fi ; \
	done ; \
	chmod +x .create-dmg/create-dmg

clean-dmgs:
	rm -f *.dmg

clean-zips:
	rm -f *.zip

clean-create-dmg:
	rm -rf .create-dmg

clean: clean-dmgs clean-zips clean-create-dmg
	rm -rf .dmg
