package flixel.rpg.dialog;

import haxe.Serializer;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class DialogSystemTest
{
	private var dialogSystem:DialogSystem;
	private var data:Array<Dynamic>;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		data = [];
		
		data.push(
		{
			id:"dialog1",
			name:"",
			texts:["Paragraph1 of dialog1","Paragraph2 of dialog1","Paragraph3 of dialog1"],
			responses:
				[
					{text:"I'm fine.", script:"action.displayDialog('dialog2');"},
					{text:"Not feeling well", script:"action.displayDialog('dialog3');", requirementScripts:["requirementFactory.create('item', {id:1, count:2, inventory:RpgEngine.levels.current.player.inventory});"]}
				]
		});
		
		data.push(
		{
			id:"dialog2",
			name:"",
			texts:["Paragraph1 of dialog2", "Paragraph2 of dialog2", "Paragraph3 of dialog2"],
			responses:
				[
					{text:"Next", script:"action.endDialog();"},					
				]
		});
		
		
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
		var dataString = Serializer.run(data);
		dialogSystem = new DialogSystem(dataString);
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