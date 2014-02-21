package flixel.rpg.requirement;
import flixel.rpg.core.RpgEngine;

/**
 * ...
 * @author Kevin
 */
class RequirementFactory implements IRequirementFactory
{
	private var factories:Map<String, RequirementData->IRequirement>;

	public function new() 
	{
		factories = new Map < String, RequirementData->IRequirement > ();
		
		// Default factories
		registerFactory("item", itemRequirementFactory);		
		
	}
	
	/**
	 * Register a factory function for a type
	 * @param	type
	 * @param	factory
	 */
	public function registerFactory(type:String, factory:RequirementData->IRequirement)
	{
		factories.set(type, factory);
	}
	
	/**
	 * @copy flixel.rpg.requirement.IRequirementFactory#create()
	 */
	public function create(data:RequirementData):IRequirement
	{
		var factory = factories.get(data.type);
		
		if (factory == null)
			throw 'Requirement factory not set for ${data.type}';
			
		return factory(data);		
	}
	
	private function itemRequirementFactory(data:RequirementData):IRequirement
	{		
		return new ItemRequirement(data.params.id, data.params.count, data.params.inventory);
	}
}


typedef RequirementData = 
{
	//TODO: should this typedef only has "type" and "params"?
	type:String,
	params:Dynamic
}

