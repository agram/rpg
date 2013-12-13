import hxd.Key in K;

class Game extends hxd.App {

	public var ents:Array<Ent>;
	public var hero:Hero;
	public var monsters:Monster.Monsters;
	public var bandeau:Bandeau;
	
	public var gfx : {
		mapElements : {
			ground: Array<h2d.Tile>,
			forest: Array<h2d.Tile>,
			house: Array<h2d.Tile>,
			fence: Array<h2d.Tile>,
			water: Array<h2d.Tile>,
			rock: Array<h2d.Tile>,
		},
		hero : {
			right: Array<h2d.Tile>,
			left: Array<h2d.Tile>,
			up: Array<h2d.Tile>,
			down: Array<h2d.Tile>,
			death: Array<h2d.Tile>,
			hitright: Array<h2d.Tile>,
			hitleft: Array<h2d.Tile>,
			hitup: Array<h2d.Tile>,
			hitdown: Array<h2d.Tile>,
		},
		monster : {
			right: Array<h2d.Tile>,
			left: Array<h2d.Tile>,
			up: Array<h2d.Tile>,
			down: Array<h2d.Tile>,
		},
		house : {
			ground: Array<h2d.Tile>,
			furniture: Array<h2d.Tile>,
			door: Array<h2d.Tile>,
			plant: Array<h2d.Tile>,
		}
	};	
	
	public var seedRand:hxd.Rand;
	public var miniMap:hxd.BitmapData;
	
	public var currentMap:Maps;
	public var backgroundMap:MapGame;
	public var backgroundHouse:Array<MapHouse>;

	public var currentBoard:h2d.Layers;
	public var board:h2d.Layers;
	public var boardHouse:Array<h2d.Layers>;
	public var ui:h2d.Layers;	
	
	override function init() {
		//var music = new flash.media.Sound(new flash.net.URLRequest("res/evoland_8b.mp3"));
		//music.play();
		
		engine.backgroundColor = 0x0000FF;
		seedRand = new hxd.Rand(3);		
		ents = [];		
		s2d.setFixedSize(Const.WIDTH, Const.HEIGHT);

		board = new h2d.Layers();
		boardHouse = [];
		boardHouse.push( new h2d.Layers() );
		boardHouse.push( new h2d.Layers() );
		
		ui = new h2d.Layers();
		
		currentBoard = board;
		s2d.add(currentBoard, Const.LAYER_SCENE_GAME);
		s2d.add(ui, Const.LAYER_SCENE_UI);
		
		initGfx();

		backgroundMap = new MapGame();
		backgroundHouse = [];
		backgroundHouse.push( new MapHouse(0) );
		backgroundHouse.push( new MapHouse(1) );

		currentMap = backgroundMap;
		
		hero = new Hero();
		monsters = new Monster.Monsters();
		
		//bandeau.tuto();
		//bandeau.currentQuest();
	}
	
	function initGfx() {
		
		miniMap = hxd.Res.map.toBitmap();
		var tile = Res.gfx.toTile();

		function split(startX, y, nb, w = 8, h = 8, dx = 0, dy = 0 ) {
			var tab = [];
			for (i in 0...nb) {
				tab.push(tile.sub(startX + i*w, y, w, h, dx, dy));
			}
			return tab;
		}

		gfx = {
			mapElements : {
				ground: split(0, 0, 10),
				forest: split(0, 8, 1, 16, 16),
				house: split(0, 32, 2, 16, 16),
				fence: split(0, 48, 6),
				water: split(0, 24, 6, 4, 2),
				rock: split(32, 32, 2, 16, 16),
			},
			hero: {
				right: split(0, 56, 2),
				left: split(0, 64, 2),
				up: split(0, 72, 2),
				down: split(0, 80, 2),
				death: split(40, 56, 1),
				hitright: split(16, 56, 1),
				hitleft: split(16, 64, 1),
				hitup: split(16, 72, 1),
				hitdown: split(16, 80, 1),
			},
			monster: {
				right: split(24, 56, 2),
				left: split(24, 64, 2),
				up: split(24, 72, 2),
				down: split(24, 80, 2),
			},
			house: {
				ground: split(0, 160, 9),
				furniture: split(0, 168, 5),
				door: split(0, 176, 2, 8, 16),
				plant: split(40, 168, 1, 8, 16),
			}
		}

		var b = split(0, 88, 1, 24, 24);
		
		bandeau = new Bandeau(b[0]);
		ui.addChild(bandeau);
	}
	
	function js( s : String ) {
		if( !flash.external.ExternalInterface.available )
				return;
		flash.external.ExternalInterface.call("eval", s);
	}
	
	override function update( dt : Float ) {	
		
		if( hero.dead && K.isPressed(K.ESCAPE) ) {
			js("document.location.reload()");
		}
		
		//s2d.add(new h2d.Bitmap(Res.title.toTile()),100);
		
		var ts = Const.TILE_SIZE;
		var gw = Const.GAME_WIDTH;
		var gh = Const.GAME_HEIGHT;
		var mw = currentMap.width;
		var mh = currentMap.height;
		
		s2d.checkEvents();
		
		for (oneEnt in ents.copy()) {
			oneEnt.update();
		}

		if(currentMap.identity == MAP) {
			var x = hero.x - gw * ts / 2;
			if (x < 0) x = 0;
			if (x > (mw - gw ) * ts) x = ( mw - gw ) * ts;
			currentBoard.x = x * (-1);
			
			var y = hero.y - gh * ts / 2;
			if (y < 0) y = 0;
			if (y > (mh - gh ) * ts ) y = ( mh - gh ) * ts;
			currentBoard.y = y * ( -1);
		}
		else if (currentMap.identity == HOUSE) {
			currentBoard.x = (Const.GAME_WIDTH - currentMap.width) / 2 * Const.TILE_SIZE;
			currentBoard.y = (Const.GAME_HEIGHT - currentMap.height) / 2 * Const.TILE_SIZE;
		}

		currentBoard.ysort(Const.LAYER_GAME); 
		
		bandeau.update();
		
		engine.render(s2d);		
	}
	
	public function enterHouse(houseX, houseY) {
		var numeroHouse = House.search(backgroundMap.tabHouse, houseX, houseY);

		currentMap = backgroundHouse[numeroHouse];
		currentMap.heroX = houseX;
		currentMap.heroY = houseY + 1;
		
		s2d.removeChild(currentBoard);
		currentBoard = boardHouse[numeroHouse];
		s2d.add(currentBoard, Const.LAYER_SCENE_GAME);
		
		hero.posX = Std.int(currentMap.width / 2 ) -1;
		hero.posY = currentMap.height - 1;
		hero.x = hero.posX * Const.TILE_SIZE;
		hero.y = hero.posY * Const.TILE_SIZE;
		
		currentBoard.add(hero, Const.LAYER_GAME);
	}
	
	public function gooutHouse() {
		hero.posX = currentMap.heroX;
		hero.posY = currentMap.heroY - 1;
		hero.x = hero.posX * Const.TILE_SIZE;
		hero.y = hero.posY * Const.TILE_SIZE;
		
		currentMap = backgroundMap;

		s2d.removeChild(currentBoard);
		currentBoard = board;
		s2d.add(currentBoard, Const.LAYER_SCENE_GAME);
		
		currentBoard.add(hero, Const.LAYER_GAME);
	}
	
	// --- 
	
	public static var inst : Game;	
	public static function main() {	
		// hxd.Res.loader = hxd.res.EmbedFileSystem.init();
		inst = new Game();
	}

}