package flixel.rpg.requirement;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.inventory.Inventory;

/**
 * ...
 * @author Kevin
 */
class RequirementFactory implements IRequirementFactory
{
	private var factories:Map<String, Dynamic->IRequirement>;

	public function new() 
	{
		factories = new Map < String, Dynamic->IRequirement > ();
		
		// Default factories
		registerFactory("item", itemRequirementFactory);		
		
	}
	
	/**
	 * Register a factory function for a type
	 * @param	type
	 * @param	factory
	 */
	public function registerFactory(type:String, factory:Dynamic->IRequirement)
	{
		factories.set(type, factory);
	}
	
	/**
	 * @copy flixel.rpg.requirement.IRequirementFactory#create()
	 */
	public function create(type:String, params:Dynamic):IRequirement
	{
		var factory = factories.get(type);
		
		if (factory == null)
			throw 'Requirement factory not set for $type';
			
		return factory(params);		
	}
	
	private function itemRequirementFactory(params:Dynamic):IRequirement
	{		
		return new ItemRequirement(params.id, params.count, params.inventory);
	}
}



