package flixel.rpg.lock;

/**
 * ...
 * @author Kevin
 */
class PasswordLock extends Lock
{
	public var password:String;
	
	public var inputBuffer(default, null):String;
	
	/**
	 * If true, automatically call checkPassword() after an input
	 */
	public var autoCheck:Bool;
	
	public function new(password:String, autoCheck:Bool = true) 
	{
		super();
		this.password = password;
		this.autoCheck = autoCheck;
		inputBuffer = "";
	}
	
	public inline function inputPassword(characters:String):Void
	{
		inputBuffer += characters;
		
		if (autoCheck)
			checkPassword();
	}
	
	public inline function resetInput():Void
	{
		inputBuffer = "";
	}
	
	public inline function checkPassword():Void
	{
		if (inputBuffer == password)
			unlock();
	}
}