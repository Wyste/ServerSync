# ServerSync
A FiveM resource to keep all players synchronized with both time and weather, with smooth transitions and wind.

## Features
- Synchronized Time for all players
- Synchronized Weather for all players
- Synchronized Wind for all weather types
- (Optional) Vehicle turn signal indicator synchronization
- (Optional) Vehicle window up/down synchronization
- Customizable weather patterns
- Customizable day / night cycle lengths.

## Changelog
v1.1
* Added chat suggestion for the /time command.
* Added error handling for weird /time arguments.

v1.2
* Fixes Typo error caused by ss_cli_indicators.lua in lines 27 and 31
* Adds functionality for turning the traffic or crowd modules on/off using `ss_enable_traffic_density` or `ss_enable_crowd_density`

## Requirements
- None. You only need this resource.

## Download / Installation

### GIT

```
cd resources
git clone https://github.com/Wyste/ServerSync.git ServerSync
```

### Manually
- Download https://github.com/Wyste/ServerSync/archive/master.zip
- Put it in the `resource/ServerSync` directory

### Installation / Activation
- [Optional] Change your options within `ServerSync\config\ServerSync.lua`
- Configure your `server.cfg` to look like this

```
ensure ServerSync
```

- Add ACE permissions to use the commands:
```
add_principal identifier.steam:110000102D010D9 group.sync #Wyste

add_ace group.sync "changeWeather" allow
add_ace group.sync "changeTime" allow
add_ace group.sync "freezeTime" allow

add_ace group.sync command.weather allow
add_ace group.sync command.time allow
add_ace group.sync command.freezetime allow

```
