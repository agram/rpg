enum TypeTile {
	FOREST;
	FALSE_FOREST;
	HOUSE;
	FENCE;
	FALSE_FENCE;
	WATER;
	PATH;
	ROCK;
	FALSE_ROCK;
	BLOCK;
	
	WALL;
	DOOR;
	PLANT;
	TABLE;
	CUPBOARD;
	
	NONE;
}

enum Identity {
	MAP;
	HOUSE;
}

class Maps
{

	public var width:Int;
	public var height:Int;
	
	public var heroX:Int;
	public var heroY:Int;
	
	var game : Game;
	public var matrix:Array<Array<TypeTile>>;
	var ground:h2d.TileGroup;
	var groundElements:h2d.TileGroup;
	
	public var identity:Identity;
	
	public function new() 
	{
		game = Game.inst;

		ground = new h2d.TileGroup(hxd.Res.gfx.toTile());
		
		matrix = [];
		for (x in 0...width) {
			matrix[x] = [];
		}
	}

		
	public function canAccess(x, y) { 
		return false;
	}
	
	public function isHouseDoor(x, y) {
		return false;
	}
}