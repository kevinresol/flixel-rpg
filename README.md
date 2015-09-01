# OBSOLETE
This library is obsolete. A newer RPG Engine is available at https://github.com/kevinresol/hare




## About [![Build Status](https://travis-ci.org/kevinresol/flixel-rpg.svg?branch=dev)](https://travis-ci.org/kevinresol/flixel-rpg)

An RPG framework based on [HaxeFlixel], including a set of essential components to build an RPG such as:
- Item/inventory/equipment system
- Trade system
- AI system
- Stats (attributes) system
- Dialog system

... and more (maybe multiplayer in the future)

## Install

flixel-rpg is still under development thus not available on haxelib yet. You may git this repo to use the library.

`haxelib git flixel-rpg https://github.com/kevinresol/flixel-rpg.git`

## Basic Usage

The core of the framework is `RpgEngine`, and the most important class is `Entity` which includes most of the 
functionalities of the framework.

Very basic example:
	
```haxe

import flixel.FlxState;
import flixel.rpg.core.RpgEngine;
import openfl.Assets;

class PlayState extends FlxState
{	
	private var rpg:RpgEngine;
	
	override public function create():Void
	{		
		super.create();
		
		if (RpgEngine.current != null)
			RpgEngine.current.destroy();
		
		var rpg = new RpgEngine();
		
		rpg.data.entityData = Assets.getText("assets/data/output/entity_data.txt");
		rpg.data.dialogData = Assets.getText("assets/data/output/dialog_data.txt");
		rpg.data.weaponData = Assets.getText("assets/data/output/weapon_data.txt");
		rpg.data.tradeData = Assets.getText("assets/data/output/trade_data.txt");
		rpg.data.levelData = Assets.getText("assets/data/output/level_data.txt");
		rpg.data.eventData = Assets.getText("assets/data/output/event_data.txt");
		rpg.data.itemData = Assets.getText("assets/data/output/item_data.txt");
		
		rpg.enableDialog();
		
		rpg.state = this;
		rpg.levels.init();
		
		rpg.events.dispatch("game_start");
	}
	
	override public function update():Void
	{
		super.update();
		
		rpg.collide();		
	}
}
```

[HaxeFlixel]: https://github.com/HaxeFlixel/flixel
