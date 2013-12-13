class MapHouse extends Maps
{
	var numeroHouse:Int;
	
	public function new(numeroHouse:Int) 
	{
		this.numeroHouse = numeroHouse;
		width = 10;
		height = 8;
		identity = HOUSE;
		
		super();
		
		var xMin = width * numeroHouse;
		
		// PARSING DE LA MAP
		var miniMap = game.miniMap;
		for (y in 0...height) {
			for(x in 0...width) {
				var pixel = miniMap.getPixel(x+xMin, y+32);
				matrix[x][y] = switch(pixel) {
					case 0xFF6D2901: 
						WALL;
					case 0xFF437999: 
						DOOR;
					case 0xFF0F6D01:  
						PLANT;
					case 0xFF6C02DA:  
						TABLE;
					case 0xFFC45818:  
						CUPBOARD;
					default:
						//throw "Missing " + StringTools.hex(pixel,8);
						NONE;
				};
			}
		}
		
		initGrounds();
		initSprites();
	
		ground.colorKey = 0xFFFFFFFF;
		game.boardHouse[numeroHouse].add(ground, Const.LAYER_BACKGROUND);		
	}

	function initGrounds() {

		var g = game.gfx.house.ground;
		
		for ( y in 1...height-1 ) {
			for( x in 1...width-1 ) {
				var type = matrix[x][y];
				var tuile = g[7];

				if ( matrix[x + 1][y] == DOOR || matrix[x - 1][y] == DOOR ) 
					tuile = g[8];
				ground.add(x * Const.TILE_SIZE, y * Const.TILE_SIZE, tuile);
			}
		}
		
	}
	
	function initSprites() {

		var gfx = game.gfx.house;

		for (y in 1...height-1) {
			groundElements = new h2d.TileGroup(Res.gfx.toTile());
			groundElements.y = y * Const.TILE_SIZE;
			for (x in 1...width-1) {
				var type = matrix[x][y];
				var tuile:h2d.Tile;
				
				inline function draw(t:h2d.Tile, x:Int) {
					groundElements.add(x * Const.TILE_SIZE, 0, t);
				}
		
				switch(type) {
					
					case WALL:
						var numWall = 0;
						var up = false, down = false, left = false, right = false;
						
						if (matrix[x - 1][y] == WALL || matrix[x - 1][y] == WALL ) left = true;
						if (matrix[x + 1][y] == WALL || matrix[x + 1][y] == WALL ) right = true;
						if (matrix[x][y-1] == WALL || matrix[x][y-1] == WALL ) up = true;
						if (matrix[x][y+1] == WALL || matrix[x][y+1] == WALL ) down = true;
						
						if (up || down) numWall = 1;
						if (right && down) numWall = 2;
						if (left && down) numWall = 3;
						if (up && right) numWall = 4;
						if (up && left) numWall = 5;
						
						draw(gfx.ground[numWall].clone(), x);
						
					case DOOR:
						if (matrix[x + 1][y] == NONE) {
							draw(gfx.ground[0].clone(), x);
							
							var tuile = gfx.door[0].clone();
							tuile.dy = -Const.TILE_SIZE;
							draw(tuile, x);
						}
						if (matrix[x - 1][y] == NONE) {
							draw(gfx.ground[0].clone(), x);
							
							var tuile = gfx.door[1].clone();
							tuile.dy = -Const.TILE_SIZE;
							draw(tuile, x);
						}
						
					case PLANT:
						var tuile = gfx.plant[0].clone();
						tuile.dy = -Const.TILE_SIZE;
						draw(tuile, x);
					
					case TABLE:
						if (matrix[x - 1][y] != TABLE) draw(gfx.furniture[0].clone(), x);
						else if (matrix[x + 1][y] != TABLE) draw(gfx.furniture[2].clone(), x);
						else draw(gfx.furniture[1].clone(), x);
					
					case CUPBOARD:
						if (matrix[x - 1][y] == CUPBOARD) draw(gfx.furniture[4].clone(), x);
						else draw(gfx.furniture[3].clone(), x);
						
					default:
				}
				
				groundElements.colorKey = 0xFFFFFFFF;
				game.boardHouse[numeroHouse].add(groundElements, Const.LAYER_GAME );
				
			}
		}
		
	}
	
	override public function canAccess(x, y) {
		return switch( matrix[x][y] ) {
			case NONE : true;
			default: false;
		}
	}
	
	override public function isHouseDoor(x, y) {
		return game.backgroundHouse[numeroHouse].height - 2 == Hero.inst.posY;
	}

}