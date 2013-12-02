package flixel.rpg.requirement;

/**
 * An interface defining a Requirement object. Basically there is only
 * one function: fulfilled() which should return true if the requirements
 * are fulfilled.
 * @author Kevin
 */
interface IRequirement
{

	public function fulfilled():Bool;
}