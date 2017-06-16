#!/bin/sh

if command -v ip &> /dev/null; then
    IP_ADDR=`ip addr show eth0 | sed -nEe 's/^\s+inet\W+([0-9.]+).*$/\1/p'`
elif command -v ifconfig &> /dev/null; then
    IP_ADDR=`ifconfig en0 | sed -nEe 's/^[[:space:]]+inet[[:space:]]+([0-9.]+).*$/\1/p'`
else
    echo "command not found"
    exit 1
fi

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>port</key>
	<integer>1080</integer>
	<key>address</key>
	<string>${IP_ADDR}</string>
</dict>
</plist>" > ThingIFSDK/ThingIFSDKMockTests/setting.plist
