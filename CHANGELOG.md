# [0.5.0] - 2/2026

## Modding

This is the modding stuff that's important to know

- ADDED SOFTCODED STAGES!
	- Filepath: `assets/backgrounds/data/stages/$stage-props.json`
- MINIMUM SUPPORTED MOD API VERSION: `0.0`
- The append system only works with `songs/data/weekList.txt` / `koya.backend.AssetTextList` entries right now
- A mod's `meta.json` file can have / require these fields:
  - `name` (optional) : Display name of the mod
  - `authors` (optional) : List of authors
  - `api_version` : The api version the mod's built for
  - `mod_version` (optional) : The mod version
- Mod assets are loaded in a first come first serve system
  - The first mod found to have an asset that's being searched for will have that asset used
- `F3 + R` reloads mods
- Mods require a `meta.json` file in their root (`mods/themod/`) for it to be loaded properly

## Visual

- Moved Song Rank display in freeplay to Song Score text
- Added outlines to Song Score and Song Composer(s) texts to Freeplay
- Text Menu Items have an alpha change instead of an animation when selected
- The FPS part of `koya.frontend.ui.Watermark` is now toggleable via the `FPS Counter` option

## General

- Fixed song info (score or combo breaks) being saved from a freeplay song playing session to a story mode playing session
- Added "Options" pause sub state item
- Z is no longer a valid Accept keybind
- P is no longer a valid Pause keybind
- ADDED KEYBIND CHANGING! (via options menu!)
- Added Mods Menu
- The Chart Editor autosave is now toggleable via the `Chart Editor Autosave` option
- Added `enabledMods` save field
- Added `preferences` save field with the following fields
  - `fpsCounter` : Toggles the fps counter
  - `chartEditorAutosave` : Toggles the chart editor autosaving
- Added Options Menu

## Technical

- Added `props` map to `koya.frontend.scenes.play.stages`
- Added support for "FlxText Menu States" : Menus using FlxText
- Removed `-DFREEPLAY_BG_GRID` define for good
- `koya.frontend.scenes.freeplay.FreeplayState` has been converted into a `MenuState`
	- All songs are now visible on freeplay (technically)
	- Song select arrows have been removed
	- Arrow alpha changes depending on conditions have been removed
	- All songs missing a chart for the current difficulty will have a -0.4 applied to their alpha
- OPTION LOOPING HAS BEEN ADDED TO `koya.frontend.scenes.menustates.StoryModeState` FOR DIFFICULTIES
- OPTION LOOPING HAS BEEN ADDED TO `koya.frontend.scenes.freeplay.FreeplayState` FOR DIFFICULTIES
- OPTION LOOPING HAS BEEN ADDED TO `koya.frontend.ui.menustate.MenuState`
	- YOU ARE NO LONGER CAPPED
- Added `-DOPTIONSMENU_CONTROLS` define
- Added full menu clearing support in `koya.frontend.ui.menustate.MenuState` via `reloadMenuItems`
- Added optional `display` variable and param to `koya.backend.save.SaveField` and it's `new` function (Used in options menu for the keybinds)
- `koya.frontend.ui.menustate.MenuState` no longer allows controls when `subState` isn't null
- Yoinked `AtlasText` from base funkin and replaced `Alphabet`
	- `koya.frontend.scenes.play.scenes.PauseSubState` has been updated to adapt
- Added `keybinds` to `koya.save.Save` (not a savefield, just a general field to help do things easy)
- Added `-DMODMENU` define : Sends you to the mod menu if `-DMOD_SUPPORT` is enabled
- Removed case-sensitivity for week JSON loading
- Added alert for when a week could not be loaded
- Fixed songs not being able to be added by `koya.backend.songs.SongList` because they were missing a normal chart (all chart files are checked for now)
- Fixed ChartingState `Reload JSON` reloading to the normal version of the song and not the current selected difficulty
- Fixed ChartingState `Reload JSON` button not reloading the desired JSON properly (It was attempting to load the JSON of `curSong`)
- Fixed ChartingState `Reload Audio` button not reloading audio properly (It was attempting to load the audio of `curSong`)
- Added `koya.backend.AssetPaths.tempDisableModCheck` : will disable the mod check stuff for one use of `koya.backend.AssetPaths.getPath`
- Removed `koya.backend.AssetPaths.pixelZoom`
- `koya.backend.CoolUtil` now has a `alert(title:String, msg:String)` function : Makes an alert obviously lol
- Added `-DMOD_SUPPORT` define : Auto-enabled on desktop builds and enables mod support as the name suggests
  - When disabled all it really does is disable the asset replacements and asset searches
- Added `koya.backend.modding.ModCore` : Manages the backend mod stuff like initalization
- Split apart MenuState flicker to its own function (Which includes the wait to run `accept` cause yes.)
- Added `-DOPTIONSMENU` define
- Added support for "Atlas Text Menu States" : Menus using the Alphabet Text
- `null` or `""` in `MenuState.accept` or `MenuState.accepted` will now `return;`
- `null` or `""` in `MenuState.itemList` will now perform `change` again with the same value in `MenuState.select`
- `MainMenuState` and `StoryModeState` have been moved to `koya.frontend.scenes.menustates`
- Removed `FlxG.log.add` from `koya.frontend.scenes.play.ComboNumbers`
- Added `koya.backend.KoyaAssets` : Assets class to help do `lime.utils.Assets` functions but support the filesystem for mods

## Misc

- Added `mods` folder
- [DEBUG] Added `example_mods` folder
  - Added `backdropMod`
- Some fixes and tweaks to the README were made

# [0.4.1] - 2/5/2026

From 0.4.1 and beyond the mod will be more focused on the technical side, if anything is to be added song or week wise it'll be by popular demand or just me being in the mood.

## Visual

- Freeplay now displays the song rank
- Fixed Monster's Composer field being Kawai Sprite
- Added "Combo breaks" section to score text
  - It shows you the total combo breaks in story mode
- Added Pico health icon
- [WEB] Fixed Watermark Font (its not VCR but its better then the \_sans font (I think that's what it is?))
  <!-- It being web only makes me mad -->
  <!-- WEB DOESNT EVEN FUCKING WORK PROPERLY! -->
- [WEB] Added Custom Preloader state (`koya.frontend.scenes.PreloaderScene`)

## Misc

- Removed week 4 and 5 assets
- `CHANGELOG.md` is no longer renamed to `changelog.txt` on compiled builds
- Added "funniboi" to README credits
- Updated README to adapt to the new direction

## Technical

- Song scores are now always saved, not just only when playing through freeplay
- `koya.backend.tasks.ResaveAllSongs` no longer contains special changes for songs
- Fixed notes passing by not being counted as misses
- `-Dindev` now enables `FLX_DEBUG`
- Crash Handler code has been moved to `koya.backend.CrashHandler`
- Removed `update_name.txt` and support for it : Update names are unrequired and can just be a community method of refering to an update

# [0.4.0] - 2/4/2026

## Added

- week 3
- EVENTS (press P to make one in the chart editor, you must have a name and a value)
  - The only event is playanim
- Added events UI... window? whatever to the chart editor
- Beats and Step to chart editor "info text"
- New assets for Daddy Dearest
- New Window Icons

## Removed

- Chart Editor Mouse Wheel support
- Note rounding

## Changed

- Antialiasing has been added back(?) to the texts without it
- The main UI items have been tweaked
- The main UI (the one with more tabs) has been resized
- On monster the camera zooms into the stage zoom
- The input system has been update to be closer to 0.3.0 FNF
- In story mode when moving to a new song the score will stay how it was at the end of the last song

## Fixed

- The freeplay texts now use the VCR font
- When entering the Chart editor the song time will always be reset to 0
- You can no longer to BEFORE the song in the chart editor
- The Chart Editor Strumline is now the correct width
  - UI Layout had to be changed because of it but it's whatev lol
- A song or week with a blank name will not save a score or rank

# [0.3.1] - 2/2/2026

## Changed

- Ranks are now saved

## Fixed

- The Week score is now saved properly
- After playing through a storymode week, the score of the last song played is no longer saved as your score

# [0.3.0] - 2/1/2026

## Changed

- Combo Popup now doesn't have a minimum length of 3

## Added

- RESULTS SCREEN!
- Added support for the combo popup to be longer then 999.

## Fixed

- Fixed Story mode not sending you to the main menu when you use the BACK control
- Fresh stageFloor not fading properly
- Main Stage curtains still playing after the first week 1 song in story mode
- Boyfriend animations being flipped
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
