# cexi-luashitacast-profiles
A set of lua files to be used with Luashitacast on the [CatsEye XI](https://www.catseyexi.com) private server for the game Final Fantasy XI.

These scripts are works-in-progress that I use for my own character in-game (Ziphion). I'm posting these publicly as a way to offer more examples for people to reference as they craft their own lua scripts. Only a few jobs are represented here (SAM, THF, WHM, BLU, BRD, BLM, SMN, RNG, GEO); as I start using other jobs more, I will add luas for them here.

## Features

These profiles add some nice quality-of-life features to the FFXI experience. Like most luashitacast profiles, these scripts handle automatic equipment swapping when engaging an enemy, casting a spell (both pre-cast and mid-cast), performing a weaponskill or job ability, performing a ranged attack, and using an item. In addition, using these profiles allows you to:

* Equip appropriate gear for different spells, weaponskills, and active job abilities (e.g. Sneak Attack)
* Equip your movement speed+ gear only when moving
* Automatically cancel sneak or stoneskin when casting those spells (requires the debuff addon). No more waiting for a 30 second cooldown on your Spectral Jig that did nothing!
* Automatically remove your shadows before casting an utsusemi spell (also requires debuff addon)
* Automatically re-equip user-defined default weapons whenever they are forcefully removed during combat (e.g. a merrow uses Torrent)
* As THF, equip treasure hunter gear whenever you engage an enemy you haven't tagged yet, and keep it equipped until you proc your preferred TH level
* As SAM, keep Saotome Haidate equipped whenever Third Eye is up and you're engaged in combat
* And much more!

## Custom Commands

These profiles add the following helpful commands to the game. If you want to use them as written, you need to set them up as aliases; see the Setup section below for more information. If your aliases aren't set, you can still use these commands using `/lac fwd`. For example, instaed of `/mdt`, you'd type `/lac fwd mdt`.

* `/pdt`, `/mdt`, `/bdt`: These commands equip your -physical damage taken, -magic damage taken, or -breath damage taken sets respectively. Any pieces you add to these sets will take preference over any other equipment during any idling action (engaged, moving, just standing there). Only one can be set at a time, and the commands are toggles; for example, typing `/pdt` equips your pdt set, then typing `/pdt` again will toggle it off, or typing `/mdt` will toggle off your pdt and replace with mdt.
* `/acc`: Increase or decrease your accuracy vs raw power. This command sets a global variable "TargetEva" to "default", "high", or "low". When you load up a script, TargetEva is set to "default".
	* If you type the command `/acc up` (or `high`, `h`, or `u`), TargetEva will be set to "high", which causes TPGain and WS sets to apply whatever higher-accuracy pieces the user wishes on top of their default TP/WS set.
	* Similarly, the command `/acc down` (or `low`, `d`, or `l`) applies a lower-accuracy, higher-power set on top of your default set.
	* Typing `/acc default` or just `/acc` will reset TargetEva to default.
* `/idle`: This command forces your "Idle" set to be equipped. This can be helpful when you need some regen/refresh/-dt while waiting for Perfect Dodge or Invincible to wear off.
* `/warpring`, `/sproutberet`, `/echadring`, `/empressband`: These commands equip the appropriate item, wait for the cooldown, use the item, and then unequip it. Helpful for when your Dedication runs out during gains.
* `/showoff`: Similar to the damage-taken and idle equipment overrides, this command replaces your idle set with a "showoff" set you can put on while AFK'ing in Lower Jeuno.
	> Unlike the damage-taken sets, your showoff set is only applied when you aren't moving or engaged in melee, so your Kupo Suit can still be equipped while you're running around town.
* `/randmount`: Randomly select a mount from a hard-coded list, or dismount if you repeat the command. Not nearly as well-featured as onimitch's mountmaster (https://github.com/onimitch/ffxi-mountmaster/tree/main) but I wanted a way to randomize from a select subset of my mounts.

### Job-Specific Custom Commands

* THF
	* `thtier`: Use this command to set your preferred level of treasure hunter you'd like to reach before swapping your TH gear to standard melee gear. By default it's set to 6, so if you tagged the mob with TH5 gear equipped, it'll swap after your first proc. `/thtier 1` or just `/thtier` will set it to swap off of your TH gear after the first proc. [More info on Treasure Hunter and the proc system](https://www.bg-wiki.com/ffxi/Treasure_Hunter)
* BLU
	* `learning`: Use this command to toggle Magus Bazubands on or off.
	* `cleave`: Enable/disable a set used for cleaving with elemental AoE spells.
* BLM
	* `freenuke`: Disabled by default, enable this to deprioritize magic burst damage+ gear.
* BRD
	* `quicksing`: Use this on a self-target song to use Pianissimo, start casting the song, then cancel Pianissimo before the song finishes casting. This allows you to take advantage of Pianissimo's shortened casting time without making the spell single target. This command does not attempt this "Pianissimo trick" if you currently have Pianissimo or Nightingale active when you use the command. You could also do this with an in-game macro, but I made this command so that I could save macro slots.
		> This command requires the Upcast addon (https://github.com/dewiniaid/ffxi-ashita-upcast). If you don't have it / don't want to use it, replace `/up` with `/ma` in your BRD.lua within profile.HandleCommand.
* SMN
	* `pupinparty` / `bstinparty`: Use this command to toggle Affinity Earring / Fidelity Earring on or off while your avatar is engaged or using a blood pact. Keep in mind that these earrings *do not work yet* in LSB (as of March 2025), so it's better to keep these toggles off for now.

## Setup

Add the lua files matching the jobs you want to play to your `ashita/config/addons/luashitacast/playername_playerid` directory. *Important*: You also need `utilities.lua` for all profiles. For THF, you also need `isTargetTagged.lua`, and for BLU, you need `bluMag.lua`. To play it safe, just add every file that starts with a lower case letter to your directory.

The following addons are required for you to be able to use these profiles:

* [Luashitacast](https://github.com/ThornyFFXI/LuAshitacast) (obviously)
* Debuff (for the /cancel functionality). This is included in the CEXI launcher, you just have to enable it.

In order to use the custom commands above, you need to add the following aliases to your `catseyexi-client/Ashita/scripts/default.txt` file.

* `/alias /warpring /lac fwd warpring`
* `/alias /sproutberet /lac fwd sproutberet`
* `/alias /echadring /lac fwd echadring`
* `/alias /empressband /lac fwd empressband`
* `/alias /acc /lac fwd acc`
* `/alias /pdt /lac fwd pdt`
* `/alias /mdt /lac fwd mdt`
* `/alias /bdt /lac fwd bdt`
* `/alias /idle /lac fwd idle`
* `/alias /showoff /lac fwd showoff`
* (THF only) `/alias /thtier /lac fwd thtier`
* (BLU only) `/alias /learning /lac fwd learning`
* (BLU only) `/alias /sird /lac fwd sird`
* (BRD only) `/alias /quicksing /lac fwd quicksing`

If you don't want to do that, you can use the full "`/lac fwd echadring`" syntax, or un-comment the code in utilities.lua that sets the aliases when each script is loaded and clears them when unloaded.
> The reason why I prefer adding these to ashita default scripts is so that I am not constantly setting and clearing aliases every time I change jobs; sometimes doing this too frequently caused my client to crash.

## Questions? Comments? Suggestions?
If you want to reach out, feel free to find me in game (Ziphion) or on discord (wccbuck). If you have a specific suggestion, you can also add it as an issue [here](https://github.com/wccbuck/cexi-luashitacast-profiles/issues).

## Special Thanks
Thank you to [Thorny](https://github.com/ThornyFFXI), [atom0s](https://github.com/atom0s), will.8627 on the Ashita discord (I don't know their github), [GetAwayCoxn](https://github.com/GetAwayCoxn) for his profile templates, and the [CatsEye](https://www.catseyexi.com) dev and admin team.
