import hxd.Key in K;

class Hero extends Ent {
	
	static var STARTX = 8;
	static var STARTY = 6;
	
	static var MOVE_SPEED = Const.TILE_SIZE;
	
	public static var inst : Hero;	
	var anim:h2d.Anim;
	
	public var posX:Int;
	public var posY:Int;
	
	public var left:Int; 
	public var right:Int;
	public var up:Int;
	public var down:Int;
	var direction:String;
	var timehit:Int;
	
	public var map:Maps;
	var bandeau:Bandeau;
 	public var quests:Quests;
	
	public function new () {
		super(Const.LAYER_GAME);
		game = Game.inst;
		map = game.currentMap;
		inst = this;
		
		left = right = up = down = 0;

		posX = STARTX;
		posY = STARTY;
		
		x = STARTX * Const.TILE_SIZE;
		y = STARTY * Const.TILE_SIZE;
		
		anim = new h2d.Anim(this);
		anim.colorKey = 0xFFFFFFFF;
		anim.speed = 5;
		anim.play(game.gfx.hero.right);
		direction = 'right';
		timehit = 0;
		
		quests = new Quests();
	}
	
	override function update() {
		
		if (dead) return;
		
		if (timehit > 1) timehit--;
		if (timehit == 1) {
			switch(direction) {
				case 'left' : anim.play(game.gfx.hero.left);
				case 'right' : anim.play(game.gfx.hero.right);
				case 'up' : anim.play(game.gfx.hero.up);
				case 'down' : anim.play(game.gfx.hero.down);
			}			
			timehit--;
		}
		
		map = game.currentMap;
		if (left == 0 && right == 0 && down == 0 && up == 0) {
			
			if (K.isDown(K.LEFT)) {
				if(game.bandeau.close()) {
					if(posX > 1 && map.canAccess(posX - 1, posY)) {
						left = Const.TILE_SIZE;
						posX--;
						anim.play(game.gfx.hero.left);
						anim.speed = 10;
						direction = 'left';
					}
				}
			}
			else if (K.isDown(K.RIGHT)) {
				if(game.bandeau.close()) {
					if(posX < map.width - 2 && map.canAccess(posX + 1, posY)) { 
						right = Const.TILE_SIZE;
						posX++;
						anim.play(game.gfx.hero.right);
						anim.speed = 10;
						direction = 'right';
					}
				}
			}
			else if (K.isDown(K.UP)) { 
				if (game.bandeau.close()) {
					
					if (map.identity == MAP && map.isHouseDoor(posX, posY - 1) )
						game.enterHouse(posX, posY-1);
					
					else if(posY > 1 && map.canAccess(posX, posY - 1)) {
						up = Const.TILE_SIZE;
						posY--;
						anim.play(game.gfx.hero.up);
						anim.speed = 10;
						direction = 'up';
					}
				}
			}
			else if (K.isDown(K.DOWN) ) {
				if(game.bandeau.close()) {
					if (map.identity == HOUSE && map.isHouseDoor(posX, posY + 1) )
						game.gooutHouse();
					
					else if(posY < map.height - 2 && map.canAccess(posX, posY + 1)) {
						down = Const.TILE_SIZE;
						posY++;
						anim.play(game.gfx.hero.down);
						anim.speed = 10;
						direction = 'down';
					}
				}
			}
			
			if (K.isPressed(K.SPACE)) {
				if(game.bandeau.close()) {
					hit();
				}
			}
			
			if (K.isPressed(K.CTRL)) {
				if(game.bandeau.close()) {
					testAction();
				}
			}
			
			if (K.isPressed("H".code)) {
				if(game.bandeau.close()) {
					game.bandeau.tuto();
				}
			}
			
			if (K.isPressed("Q".code)) {
				if(game.bandeau.close()) {
					game.bandeau.currentQuest();
				}
			}
			
			if (K.isPressed(K.ESCAPE)) {
				game.bandeau.clearMessage();
				game.bandeau.close();
			}
			
		}
		
		if (left > 0) {
			left--;
			x -= 1;
		}
		else if (right > 0) {
			right--;
			x += 1;
		}
		else if (up > 0) {
			up--;
			y -= 1;
		}
		else if (down > 0) {
			down--;
			y += 1;
		}
		else {
			anim.speed = 5;
		}
		
	}
	
	function hit() {
		timehit = 20;
		var monsterX = posX;
		var monsterY = posY;
		switch(direction) {
			case 'left' : 
				anim.play(game.gfx.hero.hitleft);
				monsterX--;
			case 'right' : 
				anim.play(game.gfx.hero.hitright);
				monsterX++;
			case 'up' : 
				anim.play(game.gfx.hero.hitup);
				monsterY--;
			case 'down' : 
				anim.play(game.gfx.hero.hitdown);
				monsterY++;
		}
		game.monsters.hit(monsterX, monsterY);
	}
	
	function testAction() {
		
		var b = game.bandeau;
		
		if(isNear(12,14)) 		quests.validate(CARRE);
		else if(isNear(22,4)) 	quests.validate(CROIX);
		else if(isNear(4,21)) 	quests.validate(ROND);
		else if(isNear(23,13)) 	quests.validate(TRIANGLE);
		
		else if(isNear(3,2)) 	quests.validate(MONTAGNE);
		else if(isNear(12,12)) 	quests.validate(MAISON);
		else if(isNear(3,12)) 	quests.validate(BOIS);
		else if (isNear(22, 28))quests.validate(VILLAGE);
		else b.open('Il n\'y a rien ici');
	}
	
	function isNear(posx, posy) {
		return ((posX == posx || posX == posx + 1 || posX == posx - 1) && posY == posy)  || ((posY == posy || posY == posy + 1 || posY == posy - 1) && posX == posx );
	}
	
	public function death() {
		dead = true;
		hxd.Res.deadHero.play();
		anim.play(game.gfx.hero.death);
		
		var cr = 5;
		for ( i in 0...10 ) {
			var part = new Particule(DEATH);
			part.pv = Std.random(10)+40;
			part.x = x + part.vx * cr;
			part.y = y + part.vy * cr;
			part.frict = 0.92 + Math.random() * 0.04;
		}
		
		game.bandeau.open('Perdu ! ESC pour rejouer');
	}
}