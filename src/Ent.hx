class Ent extends h2d.Sprite
{
	var vx:Float;
	var vy:Float;
	var vz:Float;
	var z:Float;
	var frict:Float;
	public var pv:Int;
	public var dead:Bool;	
	
	var game:Game;
	
	public function new (layer:Int = -1)
	{
		if (layer == -1) layer = Const.LAYER_GAME;
		super();
		game = Game.inst;
		game.ents.push(this);
		game.currentBoard.add(this, layer);
		pv = 1;
		vx = 0;
		vy = 0;
		vz = 0;
		z = 0;
		frict = 1;
		dead = false;
	}
	
	public function update ()
	{
		x += vx;
		y += vy;
		z += vz;
		vx *= frict;
		vy *= frict;
		vz *= frict;
	}
	
	public function looseLife(nb:Int = 1) 
	{
		pv -= nb;
		if (pv <= 0)
			destroy();
	}
	
	function destroy()
	{
		kill();
	}
	
	function kill() 
	{
		dead = true;
		game.ents.remove(this);
		remove();
	}		
}