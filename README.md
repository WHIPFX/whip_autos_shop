# whip_autos_shop

The WHIPLASH building in Burton: the drive-in shop for [whip_autos](https://github.com/WHIPFX/whip_autos), WHIP's car
customisation shop. It takes the place of Los Santos Customs in Burton, with Rockstar's Tuners Auto Shop inside: a car
lift, a paint booth, and a roller door from the car park that opens for anyone on foot or in a car.

It's a map resource with one small client script, for both FiveM Legacy (`stream/`) and GTA V Enhanced
(`stream_enhanced/`).

## Requirements

None. It's built for [whip_autos](https://github.com/WHIPFX/whip_autos), whose shop floor is the lift inside.

## Installation

WHIP's txAdmin recipe installs it.

By hand, put `whip_autos_shop` in your `resources` folder and add this line to `server.cfg`, after
`ensure whip_core`:

```cfg
ensure whip_autos_shop
```

**Don't restart whip_autos_shop while players are on.** The interior unloading under them crashes their games, so
restart the whole server instead. Restarting `whip_autos` or `whip_core` leaves the building alone.

## Compatibility

The building streams its own copies of Rockstar's map files for its block: the `bt1_02` files and the `ss1_occl_00`
occlusion maps in `stream/`. Another map that streams any of those names, or changes Los Santos Customs in Burton,
clashes with it. Los Santos Customs at the airport is untouched.

## Doors

The roller door and the paint booth door aren't in WHIP's Door System, so anyone can open them. To lock the roller
door, save it as a door in the Door System: model `whiplash_shop_door` at `-349.824, -117.245, 38.103`.

## License

whip_autos_shop's code is licensed under the GNU LGPL 3.0; see `COPYING.LESSER`, and `COPYING` for the GPL 3.0 it
builds on. Its map files are made from Grand Theft Auto V and belong to Rockstar Games: WHIP's licence doesn't cover
them. See `NOTICE.md`, and `whip_core`'s `NOTICE.md` for the full notice.
