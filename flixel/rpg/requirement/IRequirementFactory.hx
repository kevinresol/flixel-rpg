package flixel.rpg.requirement;
import flixel.rpg.requirement.RequirementFactory.RequirementData;
/**
 * ...
 * @author Kevin
 */
interface IRequirementFactory
{
	/**
	 * Create a IRequirement instance from data
	 * @param	data
	 * @return
	 */
	function create(type:String, params:Dynamic):IRequirement;
}