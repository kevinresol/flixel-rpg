package flixel.rpg.inventory;

import flixel.rpg.inventory.Inventory;
import flixel.rpg.inventory.InventoryItem;
import haxe.Serializer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;


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
		var data = [{id:1, type:0, displayName:"Key Card", maxStack:1}];
		var dataString = Serializer.run(data);
		
		InventoryItem.loadData(dataString);
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{		
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
	public function testCountItem():Void
	{
		inventory.createEmptySlots(1);		
		inventory.addItem(item);		
		
		Assert.isTrue(inventory.countItem(1) == 1);
	}
	
	@Test
	public function testCountEmptySlot():Void
	{
		Assert.isTrue(inventory.countEmptySlot(1) == 0);
		
		inventory.createEmptySlots(1);
		Assert.isTrue(inventory.countEmptySlot(1) == 1);
		
		inventory.addItem(item);
		Assert.isTrue(inventory.countEmptySlot(1) == 0);
		
		inventory.removeItem(1, 1);
		Assert.isTrue(inventory.countEmptySlot(1) == 1);
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
		Assert.isTrue(inventory.has(1, 1));
	}
	
	

}