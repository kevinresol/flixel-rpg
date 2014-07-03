package flixel.rpg.dialog;

import flixel.FlxState;
import flixel.rpg.core.RpgEngine;
import haxe.Serializer;
import massive.munit.Assert;


class DialogSystemTest
{
	private var rpg:RpgEngine;
	private var dialogSystem:DialogSystem;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		var data = [];
		
		data.push(
		{
			id:"dialog1",
			name:"",
			texts:["Paragraph1 of dialog1","Paragraph2 of dialog1","Paragraph3 of dialog1"],
			responses:
				[
					{text:"I'm fine.", action:"RpgEngine.dialog.display('dialog2');"},
					{text:"Not feeling well", action:"RpgEngine.dialog.display('dialog3');", requirement:"RpgEngine.levels.current.player.inventory.has(1,2);"}
				]
		});
		
		data.push(
		{
			id:"dialog2",
			name:"",
			texts:["Paragraph1 of dialog2", "Paragraph2 of dialog2", "Paragraph3 of dialog2"],
			responses:
				[
					{text:"Next", action:"RpgEngine.dialog.end();"},					
				]
		});
		
		var dataString = Serializer.run(data);
		
		rpg = new RpgEngine();
		rpg.data.dialogData = dataString;
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
		dialogSystem = new DialogSystem(rpg);
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function testConstructor():Void
	{
		Assert.isTrue(dialogSystem != null);
	}	
	
	@Test
	public function testDisplay():Void
	{
		Assert.isTrue(dialogSystem.current == null);
		
		dialogSystem.display("dialog1");
		
		Assert.isTrue(dialogSystem.current.id == "dialog1");		
		Assert.isTrue(dialogSystem.current.text == "Paragraph1 of dialog1");
	}	
	
	@Test
	public function testShowNext():Void
	{		
		dialogSystem.display("dialog1");
		dialogSystem.showNext();
		
		Assert.isTrue(dialogSystem.current.id == "dialog1");		
		Assert.isTrue(dialogSystem.current.text == "Paragraph2 of dialog1");
		
		dialogSystem.showNext();
		
		Assert.isTrue(dialogSystem.current.id == "dialog1");		
		Assert.isTrue(dialogSystem.current.text == "Paragraph3 of dialog1");
	}
	
	@Test
	public function testEnd():Void
	{		
		dialogSystem.display("dialog1");
		dialogSystem.end();
		
		Assert.isTrue(dialogSystem.current == null);
	}
	

	@Test
	public function testGetDialog():Void
	{		
		dialogSystem.display("dialog1");
		
		Assert.isTrue(dialogSystem.current == dialogSystem.getDialog("dialog1"));		
	}}