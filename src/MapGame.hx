import hxd.Key in K;

class MapGame extends Maps {
	
	public var tabHouse:Array<House>;
	
	public function new () {
		width = 32;
		height = 32;
		identity = MAP;
		
		super();

		tabHouse = [];
		
		var miniMap = game.miniMap;
		for (y in 0...height) {
			for(x in 0...width) {
				var pixel = miniMap.getPixel(x, y);
				matrix[x][y] = switch(pixel) {
					case 0xFF016D1B: 
						FOREST;
					case 0xFF214D2C: 
						FALSE_FOREST;
					case 0xFFDA5302:  
						HOUSE;
					case 0xFF572F17:  
						FENCE;
					case 0xFF996343:  
						FALSE_FENCE;
					case 0xFF4DFDFC:  
						WATER;
					case 0xFFE8FD4D:  
						PATH;
					case 0xFF82AEC8: 
						ROCK;
					case 0xFF8A82C8: 
						FALSE_ROCK;
					default:
						//throw "Missing " + StringTools.hex(pixel,8);
						NONE;
				};
			}
		}
		initGrounds();
		initSprites();
	
		ground.colorKey = 0xFFFFFFFF;
		game.board.add(ground, Const.LAYER_BACKGROUND);
	}
	
	function initGrounds() {

		var g = game.gfx.mapElements.ground;
		var s = game.seedRand;
		var nbNone = 4;
		var startForest = 4;
		var nbForest = 3;
		
		for ( y in 1...height-1 ) {
			for( x in 1...width-1 ) {
				var type = matrix[x][y];
				
				inline function hasNear(t) {
					return matrix[x - 1][y] == t || matrix[x + 1][y] == t || matrix[x][y - 1] == t || matrix[x][y + 1] == t;
				}
				var tuile = g[s.random(nbNone)];
				
				switch(type) {
					case FOREST, FALSE_FOREST:
						tuile = g[s.random(nbForest) + startForest];
					case HOUSE: 
					case FENCE, FALSE_FENCE: 
						if ( hasNear(WATER) )
							tuile = g[7];
						if ( hasNear(FOREST) || hasNear(FALSE_FOREST) )
							tuile = g[s.random(nbForest) + startForest];
					case WATER:  
						tuile = g[7];
					case PATH:  
						tuile = g[8];
					case ROCK, FALSE_ROCK:  
						tuile = g[9];
					default:
						// Si une tuile vide se trouve pres d'un rocher, il prend le sol des montagnes
						if ( hasNear(ROCK) || hasNear(FALSE_ROCK) )
							tuile = g[9];
						// pareil pour les arbres
						if ( hasNear(FOREST) || hasNear(FALSE_FOREST)) {
							tuile = g[s.random(nbForest) + startForest];
						}
						// pareil pour les BLOCK
						if ( (matrix[x - 1][y-1] == FOREST ||  matrix[x - 1][y - 1] == FALSE_FOREST)) {
							tuile = g[s.random(nbForest) + startForest];
						}
						if ( (matrix[x - 1][y-1] == ROCK ||  matrix[x - 1][y - 1] == FALSE_ROCK)) {
							tuile = g[9];
						}
						if ( (matrix[x + 1][y-1] == FOREST ||  matrix[x + 1][y - 1] == FALSE_FOREST)) {
							tuile = g[s.random(nbForest) + startForest];
						}
						if ( (matrix[x + 1][y-1] == ROCK ||  matrix[x + 1][y - 1] == FALSE_ROCK)) {
							tuile = g[9];
						}
		
						
				}
				
				ground.add(x * Const.TILE_SIZE, y * Const.TILE_SIZE, tuile);
			}
		}
		
		for (x in 0...width) {
			ground.add(x * Const.TILE_SIZE, 0, g[s.random(nbNone)]);
			ground.add(x * Const.TILE_SIZE, (height-1) * Const.TILE_SIZE, g[s.random(nbNone)]);
		}
		for (y in 0...height) {
			ground.add(0, y * Const.TILE_SIZE, g[s.random(nbNone)]);
			ground.add((height-1) * Const.TILE_SIZE, y * Const.TILE_SIZE, g[s.random(nbNone)]);
		}
	}

	function initSprites() {
		
		var gfx = game.gfx.mapElements;
		var s = game.seedRand;
		
		for (y in 1...height-1) {
			groundElements = new h2d.TileGroup(Res.gfx.toTile());
			groundElements.y = y * Const.TILE_SIZE;
			for (x in 1...width-1) {
				var type = matrix[x][y];
				var tuile:h2d.Tile;
				
				inline function rnd(e:Array<h2d.Tile>) {
					return e[s.random(e.length)].clone();
				}
				
				inline function draw(t:h2d.Tile, x:Int) {
					groundElements.add(x * Const.TILE_SIZE, 0, t);
				}
				
				
				switch(type) {
					case WATER :
						var tuile = rnd(gfx.water);
						tuile.dy = s.random(4) + 2;
						draw(tuile, x);

					case FOREST, FALSE_FOREST:
						var tuile = gfx.forest[0].clone();
						tuile.dx = -Const.TILE_SIZE + 4;
						tuile.dy = -Const.TILE_SIZE + 2 ;
						draw(tuile, x);

					case HOUSE : 	
						var numeroHouse = s.random(2);
						var tuile = gfx.house[numeroHouse].clone();
						tuile.dy = -Const.TILE_SIZE;
						draw(tuile, x);

						if (matrix[x + 1][y] == NONE && type == HOUSE) {
							matrix[x+1][y] = BLOCK;
						}
		
						tabHouse.push(new House(x, y, numeroHouse));

					case FENCE, FALSE_FENCE:
						var numFence = 0;
						var up = false, down = false, left = false, right = false;
						
						if (matrix[x - 1][y] == FENCE || matrix[x - 1][y] == FALSE_FENCE ) left = true;
						if (matrix[x + 1][y] == FENCE || matrix[x + 1][y] == FALSE_FENCE ) right = true;
						if (matrix[x][y-1] == FENCE || matrix[x][y-1] == FALSE_FENCE ) up = true;
						if (matrix[x][y+1] == FENCE || matrix[x][y+1] == FALSE_FENCE ) down = true;
						
						if (up || down) numFence = 1;
						if (right && down) numFence = 2;
						if (left && down) numFence = 3;
						if (up && right) numFence = 4;
						if (up && left) numFence = 5;
						
						draw(gfx.fence[numFence].clone(), x);
					
					case ROCK, FALSE_ROCK: 
						var tuile = gfx.rock[s.random(2)].clone();
						tuile.dx = -2;
						tuile.dy = -Const.TILE_SIZE + 4 ;
						draw(tuile, x);

						if (matrix[x + 1][y] == NONE && type == ROCK) {
							matrix[x+1][y] = BLOCK;
						}
						
					default:
				}
			}
			
			groundElements.colorKey = 0xFFFFFFFF;
			game.board.add(groundElements, Const.LAYER_GAME );
		}
	}
	
	override public function canAccess(x, y) {
		return switch( matrix[x][y] ) {
			case NONE, PATH, FALSE_FOREST, FALSE_FENCE, FALSE_ROCK : true;
			default: false;
		}
	}
	
	override public function isHouseDoor(x, y) {
		return matrix[x][y] == HOUSE;
	}

}