# [0.3.0] - 2/2026

## Fixed
- When you are on the last song of a week, the game no longer crashes trying to load another song

# [0.2.3] - 2/1/2026

This is just a quick hotfix to fix the game from being busted.

# [0.2.2] - 2/1/2026

## Fixed
- The original control keybinds system still being applied
- Crash when selecting "Monster" on freeplay
- Cursor being visible when it shouldn't be

# [0.2.1] - 2/1/2026

A quick save patch update

## Added
- Added 1 second wait until starting to let the save class do its thing

## SAVE VERSION 2:
- Save fields are initialized (properly now) before ANY attempt at loading save information
- The save will now always attempt to upgrade
- Fixed save data saving on exit not being applied when you didn't require an upgrade
- Save fields have to be null for their initial value to be set
- All keybinds are saved in your save data now

# [0.2.0] - 2/1/2026

## Fixed

- On songs with a fade intro if BF isnt faded in when you die he will fade in during the gameover
- Song scores are no longer saved in charting mode
- Fixed icons bopping too fast
- All note strume times in all charts no longer have decimal points
- Freeplay now says "Composer(s)" and not "Composers"

## Changed

- The FPS text now has the version text
- The FPS text now has the VCR font
- The logo now flys up after pressing enter on the title screen
- Weeks now control the song list

## Added

- WEEK 2 KOYA!!!
- STORY MODE!!
- MAIN MENU!
- Difficulty changing via the pause menu!
- "Event Notes"
- `weekList` text file
- Face health icon for when a health Icon cannot be found

## Removed

- Version text from Title screen
- `freeplaySongList` text file
- Unused `iconGrid` image

# [0.1.1] - 1/31/2026

## Changed

- Crash Handler File Path's now can be control-clicked by VSC or VSCodium (The format was changed so now it'll work and idfk if any other editors will work with that)

## Fixed

- Sustain Notes being offset from the note
- The gameplay camera no longer moves in the pause screen
- titleShoot no longer plays when pressing enter when freakyMenu is playing
- Pause screen text going out of bounds.
- Fresh fade intro not being functional on release builds

# [0.1.0] - 1/31/2026

Inital Release with the following:

- [WEB] Touch Here To Play Screen
- Title Screen
- Freeplay
- Tutorial + Week 1 Koya Versions
