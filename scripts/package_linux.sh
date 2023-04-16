#! /bin/bash

SCRIPT_DIR=${BASH_SOURCE%/*}
. "$SCRIPT_DIR/version.sh"

WEBRTC_RB="webrtc"

echo "Packaging header files"
rm -rf ./$WEBRTC_RB 2> /dev/null
mkdir -p ./$WEBRTC_RB/include
echo WEBRTC_RELEASE=$WEBRTC_RELEASE > ./$WEBRTC_RB/version.txt
echo WEBRTC_COMMIT=$WEBRTC_COMMIT >> ./$WEBRTC_RB/version.txt
find webrtc_checkout/src -type f -iname "*.h" -exec scripts/cpheader.sh {} ./$WEBRTC_RB \;
zip -9r ${WEBRTC_VER}_headers.zip ./$WEBRTC_RB version.txt
rm -rf ./$WEBRTC_RB 2> /dev/null

AVS_OS="linux"

echo "Packaging $AVS_OS files"

for p in webrtc_checkout/src/out/${AVS_OS}*; do
	dst=./$WEBRTC_RB/lib/${p/webrtc_checkout\/src\/out\//}
	if [ -e $p/obj/libwebrtc.a ]; then
		mkdir -p $dst
		cp $p/obj/libwebrtc.a $dst/
	fi
done

if [ -e ./$WEBRTC_RB ]; then
	zip -9r ${WEBRTC_VER}_${AVS_OS}.zip  ./$WEBRTC_RB
	rm -rf ./$WEBRTC_RB 2> /dev/null
fi


