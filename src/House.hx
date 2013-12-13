class House
{

	var x:Int;
	var y:Int;
	var type:Int;
	
	public function new(x, y, type) {
		this.x = x;
		this.y = y;
		this.type = type;
	}

	public static function search(tab:Array<House>, x, y) {
		var a;
		a = 0;
		for (h in tab) if (h.x == x && h.y == y) a = h.type;
		
		return a;
	}
}