class Monsters
{
	var all:Array<Monster>;
	
	public function new() 
	{
		all = [];
		all.push(new Monster(14, 6));
		all.push(new Monster(6, 12));
		all.push(new Monster(11, 15));
		all.push(new Monster(20, 4));
	}
	
	public function hit(monsterX, monsterY) {
		for (m in all) if (m.posX == monsterX && m.posY == monsterY) m.death();
	}
}

class Monster extends Ent
{
	public var left:Int; 
	public var right:Int;
	public var up:Int;
	public var down:Int;

	public var posX:Int;
	public var posY:Int;
	
	var anim:h2d.Anim;

	public var map:Maps;
	
	var timeMove:Int;
	
	public function new(posX, posY) 
	{
		super();
		
		left = right = up = down = 0;
		
		map = game.currentMap;
		game.currentBoard.add(this, Const.LAYER_GAME);
		
		this.posX = posX;
		this.posY = posY;
		x = posX * Const.TILE_SIZE;
		y = posY * Const.TILE_SIZE;

		anim = new h2d.Anim(this);
		anim.colorKey = 0xFFFFFFFF;
		anim.speed = 5;
		anim.play(game.gfx.monster.right);
		
		timeMove = 0;
	}
	
	override public function update() {
		if (game.currentMap.identity != MAP) return;
		
		map = game.currentMap;
		if (left == 0 && right == 0 && down == 0 && up == 0) {
			if (timeMove <= 0) {
				deplacement();
				timeMove = 30 + Std.random(30);
			}
			else timeMove--;
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
		
		if (Hero.inst.dead) return;
		else if (posX == Hero.inst.posX && posY == Hero.inst.posY) Hero.inst.death();
		
	}
	
	function deplacement () {
		
		if (Hero.inst.dead) return;			
		
		var path = new Path(Hero.inst.posX, Hero.inst.posY, posX, posY);
		var item = path.retour;
		
		if(item.x != -1 && item.y != -1) {
			if (item.x < posX) {
				left = Const.TILE_SIZE;
				posX--;
				anim.play(game.gfx.monster.left);
			}
			else if (item.x > posX) {
				right = Const.TILE_SIZE;
				posX++;
				anim.play(game.gfx.monster.right);
			}
			else if (item.y < posY) {
				up = Const.TILE_SIZE;
				posY--;
				anim.play(game.gfx.monster.up);
			}
			else if (item.y > posY) {
				down = Const.TILE_SIZE;
				posY++;
				anim.play(game.gfx.monster.down);
			}
		}
		
		//else {
			//switch (Std.random(4)) {
			//
				//case 0:
					//if(posX > 1 && map.canAccess(posX - 1, posY)) {
						//left = Const.TILE_SIZE;
						//posX--;
						//anim.play(game.gfx.monster.left);
					//}
					//else
						//deplacement();
				//case 1:
					//if(posX < map.width - 2 && map.canAccess(posX + 1, posY)) { 
							//right = Const.TILE_SIZE;
						//posX++;
						//anim.play(game.gfx.monster.right);
					//}
					//else
						//deplacement();
				//case 2:					
					//if(posY > 1 && map.canAccess(posX, posY - 1)) {
						//up = Const.TILE_SIZE;
						//posY--;
						//anim.play(game.gfx.monster.up);
					//}
					//else
						//deplacement();
				//case 3:
					//if(posY < map.height - 2 && map.canAccess(posX, posY + 1)) {
						//down = Const.TILE_SIZE;
						//posY++;
						//anim.play(game.gfx.monster.down);
					//}
					//else
						//deplacement();
				//default:
			//}
		//}
	}
	
	public function death() {
		hxd.Res.deadMonster.play();
		var cr = 5;
		for ( i in 0...10 ) {
			var part = new Particule(DEATH);
			part.pv = Std.random(10)+40;
			part.x = x + part.vx * cr;
			part.y = y + part.vy * cr;
			part.frict = 0.92 + Math.random() * 0.04;
		}
		kill();
	}
}