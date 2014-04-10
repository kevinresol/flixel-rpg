package flixel.rpg.inventory;

import flixel.rpg.inventory.Inventory;
import flixel.rpg.inventory.InventoryItem;
import haxe.Serializer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class InventoryTest 
{
	private var timer:Timer;
	
	private var inventory:Inventory;
	private var item:InventoryItem;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
		var data = [{id:1, type:0, displayName:"Key Card", maxStack:1}];
		var dataString = Serializer.run(data);
		
		InventoryItem.loadData(dataString);
		
		inventory = Inventory.get();
		item = InventoryItem.get(1, 1);
	}
	
	@After
	public function tearDown():Void
	{
		
	}
	
	@Test
	public function testAddWithoutSlot():Void
	{
		Assert.isFalse(inventory.addItem(item));
	}
	
	@Test
	public function testAddWithSlot():Void
	{
		inventory.createEmptySlots(1);		
		Assert.isTrue(inventory.addItem(item));		
	}
	
	
	@Test
	public function testHas():Void
	{
		inventory.createEmptySlots(1);		
		inventory.addItem(item);		
		
		Assert.isTrue(inventory.has(1, 1));
		Assert.isFalse(inventory.has(1, 2));
		Assert.isFalse(inventory.has(2, 1));
	}
	
	@Test
	public function testCount():Void
	{
		inventory.createEmptySlots(1);		
		inventory.addItem(item);		
		
		Assert.isTrue(inventory.countStack(1) == 1);
	}
	
	
	@Test
	public function testRemove():Void
	{
		inventory.createEmptySlots(1);		
		inventory.addItem(item);		
		
		Assert.isTrue(inventory.removeItem(1, 1));		
	}
	
	@Test
	public function testRemoveWithoutAdd():Void
	{		
		Assert.isFalse(inventory.removeItem(1, 1));		
	}
	
	@Test
	public function testOverRemove():Void
	{
		inventory.createEmptySlots(1);		
		inventory.addItem(item);
		Assert.isFalse(inventory.removeItem(1, 2));
		//Assert.isTrue(inventory.has(1, 1));
	}
	
	
	@Test
	public function testExample():Void
	{
		Assert.isTrue(true);
	}
	
	@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}
	
	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}
	
	
	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}

}