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
- Change your options within `ServerSync\config\ServerSync.lua`
- Configure your `server.cfg` to look like this

```
ensure ServerSync
```
