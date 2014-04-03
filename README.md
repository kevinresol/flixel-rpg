## About

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

import flixel.rpg.state.GameState;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;

class PlayState extends GameState
{	
	override public function create():Void
	{		
		super.create();
		
		RpgEngine.init(this);
		RpgEngine.levels.register("Level 1", new LevelOne()); //LevelOne extends Level		
		RpgEngine.levels.switchTo("Level 1");
		
		var e = new Entity();
		e.enableAI();
		e.ai.add(new SomeAI()); // SomeAI implments IAI
		
		e.enableInventory();		
		e.inventory.createEmptySlots(0, 4); // Create 4 slots of type 0
		
		e.enableEquipments(); // Equipment Slots (just another Inventory instance)
		e.enableEquipments.createEmptySlots(1); // Create a slot of type 1
		e.enableEquipments.createEmptySlots(2); // Create a slot of type 2
		e.enableEquipments.createEmptySlots(3); // Create a slot of type 3
		
		e.enableWeapon();		
		e.enableStat();
		
		e.enableDialogueInitializer();		
		e.dialogInitializer.dialogId = "some_dialog_id";
		
		RpgEngine.levels.current.registerPlayer(e);
	}
	
	override public function update():Void
	{
		super.update();
		
		RpgEngine.collide();		
	}
}
```

[HaxeFlixel]: https://github.com/HaxeFlixel/flixel