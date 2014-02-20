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
	function create(data:RequirementData):IRequirement;
}