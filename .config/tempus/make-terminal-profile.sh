#!/bin/sh
# Build "Tempus Future.terminal", a macOS Terminal.app profile, from the hex
# palette in ./colors. Terminal.app can't have its palette set by escape codes
# (see shell.sh), so it needs this profile instead. To use it:
#   open "~/.config/tempus/Tempus Future.terminal"
# then Terminal > Settings > Profiles > Tempus Future > Default.
#
# Usage: make-terminal-profile.sh [output file]
set -e

dir=$(cd "$(dirname "$0")" && pwd)
. "$dir/colors"
out=${1:-"$dir/Tempus Future.terminal"}

# Profile key -> hex color, one per line, for the JavaScript below
colors="BackgroundColor $TEMPUS_HEX_BG
TextColor $TEMPUS_HEX_FG
TextBoldColor $TEMPUS_HEX_FG
CursorColor $TEMPUS_HEX_FG
SelectionColor $TEMPUS_HEX_8
ANSIBlackColor $TEMPUS_HEX_0
ANSIRedColor $TEMPUS_HEX_1
ANSIGreenColor $TEMPUS_HEX_2
ANSIYellowColor $TEMPUS_HEX_3
ANSIBlueColor $TEMPUS_HEX_4
ANSIMagentaColor $TEMPUS_HEX_5
ANSICyanColor $TEMPUS_HEX_6
ANSIWhiteColor $TEMPUS_HEX_7
ANSIBrightBlackColor $TEMPUS_HEX_8
ANSIBrightRedColor $TEMPUS_HEX_9
ANSIBrightGreenColor $TEMPUS_HEX_10
ANSIBrightYellowColor $TEMPUS_HEX_11
ANSIBrightBlueColor $TEMPUS_HEX_12
ANSIBrightMagentaColor $TEMPUS_HEX_13
ANSIBrightCyanColor $TEMPUS_HEX_14
ANSIBrightWhiteColor $TEMPUS_HEX_15"

# Terminal.app stores colors as archived NSColor objects, so let AppKit
# (via JavaScript for Automation) write the file
COLORS=$colors OUT=$out osascript -l JavaScript <<'EOF'
ObjC.import('AppKit')
const env = $.NSProcessInfo.processInfo.environment
const get = (k) => ObjC.unwrap(env.objectForKey(k))

const profile = $.NSMutableDictionary.dictionary
profile.setObjectForKey('Tempus Future', 'name')
profile.setObjectForKey('Window Settings', 'type')
profile.setObjectForKey($.NSNumber.numberWithDouble(2.07), 'ProfileCurrentVersion')
// Keep bold text in the bold color instead of switching to bright colors
profile.setObjectForKey($.NSNumber.numberWithBool(false), 'UseBrightBold')

for (const line of get('COLORS').split('\n')) {
	const [key, hex] = line.split(' ')
	const n = (i) => parseInt(hex.slice(i, i + 2), 16) / 255
	const color = $.NSColor.colorWithSRGBRedGreenBlueAlpha(n(1), n(3), n(5), 1)
	const data = $.NSKeyedArchiver.archivedDataWithRootObjectRequiringSecureCodingError(color, true, null)
	profile.setObjectForKey(data, key)
}

const out = get('OUT')
if (!profile.writeToFileAtomically(out, true)) throw new Error('could not write ' + out)
EOF
echo "Wrote $out"
