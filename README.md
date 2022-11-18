# holo_city

If you just want to play the map: [download BSP](https://github.com/OfficialExtan/holo_city/raw/main/maps/holo_city.bsp)

So I recently found out about VScript and started to experiment with it. This is just a proof of concept of a hologram showing player positions in realtime.
The player models and lasers also change color when a player shoots. A skull sprite (which disappears after a few seconds) marks the position of a player death.
The hologram can be turned on and off via the interface next to it.
I tested everything many times and it works pretty well up to a maximum of 10 players.
With more players it starts to lag a bit but I think that's just because of my really bad code and I only tested it locally.
Please feel free to improve my code and make pull requests if you want to! :)

VScript (or Squirrel, the programming language of VScript) is really cool and you can do much more with it than you think.
It allows to write scripts built into the map/BSP file which means you don't need any additional plugins like SourceMod to run it.
Some people wrote entire aimbots, maze generators or chess AI!
I recommend these sites and tutorials if you want to know more:

- [VScript Fundamentals by Valve](https://developer.valvesoftware.com/wiki/VScript_Fundamentals)
- [VScript Examples by Valve](https://developer.valvesoftware.com/wiki/CS:GO_VScript_Examples)
- [YouTube Tutorial Series by TheE7Player](https://youtube.com/playlist?list=PLTsWR3-f6-rCamvtaQreqm7fyCJDMEQGO)
- [YouTube Tutorial Series by TopHATTwaffle](https://youtube.com/playlist?list=PL-454Fe3dQH1L38FnKkz_O1CqYx6sKaXk)
- [A very powerful VScript library I used for this project](https://github.com/samisalreadytaken/vs_library)

## Video Demo
[YouTube](https://www.youtube.com/watch?v=0QpWfAvWDVk)

## Screenshots
![overview](https://i.imgur.com/ii0okW2.png)

![top view](https://i.imgur.com/0iWQqfT.png)

![close-up #1](https://i.imgur.com/pbvVrbF.png)

![close-up #2](https://i.imgur.com/mZuzf6J.png)

![turned off](https://i.imgur.com/KpHVRiq.png)
