typedef Item = {
	x:Int,
	y:Int,
	distance:Float,
	cost:Int,
}

class PathOld
{
	var open:Array<Item>;
	public var closed:Array<Item>;
	var map:Maps;
	var start:Item;
	var goal:Item;

	public function new(startX, startY, goalX, goalY) {
		map = Game.inst.currentMap;
		
		open = [];
		closed = [];
		
		start = { x:startX, y:startY, distance:0, cost: 0 };
		goal = { x:goalX, y:goalY, distance:0, cost: 0 };

		iterate();
	}
	
	function iterate() {
		start.distance = distance(start, goal);
		open.push( start );
		while (open.length > 0) {
			var current = open.shift();
			closed.push(current);
			if (current.x == goal.x && current.y == goal.y) break;
			
			var tabNeighbors = getNeighbors(current);
			for (n in tabNeighbors) {
				existsInOpenButCostly(n);
				existsInClosedButCostly(n);
				if (!existsIn(n, open) && !existsIn(n, closed)) {
					open.push(n);
				}
			}
			
			open.sort( function(a:Item, b:Item):Int
			{
				if (a.distance < b.distance) return -1;
				if (a.distance > b.distance) return 1;
				return 0;
			} );
		}
	}
	
	static function existsIn(n:Item, tab:Array<Item>) {
		for (i in 0...tab.length) 
			if (tab[i].x == n.x && tab[i].y == n.y)
				return true;
		return false;
	}
	
	function existsInOpenButCostly(n:Item) {
		for (i in 0...open.length) {
			if (open[i].x == n.x && open[i].y == n.y && open[i].cost > n.cost) {
				open.remove(open[i]);
				return;
			}
		}
	}
	
	function existsInClosedButCostly(n:Item) {
		for (i in 0...closed.length) {
			if (closed[i].x == n.x && closed[i].y == n.y && closed[i].cost > n.cost) {
				closed.remove(closed[i]);
				return ;
			}
		}
	}
	
	static function distance(d:Item, a:Item) 
	{
		return Math.sqrt(Math.pow(d.x - a.x, 2) + Math.pow(d.y - a.y, 2));
	}
	
	function getNeighbors(i:Item) {
		var t = [];
		
		if(i.x > 0 && map.canAccess(i.x-1, i.y)) {
			var n1:Item = { x:i.x-1, y:i.y, distance:0, cost:i.cost+1 };
			n1.distance = distance(goal, n1);
			t.push(n1);
		}
		if(i.x < map.width - 1 && map.canAccess(i.x+1, i.y)) {
			var n2:Item = { x:i.x+1, y:i.y, distance:0, cost:i.cost+1 };
			n2.distance = distance(goal, n2);
			t.push(n2);
		}
		if(i.y > 0 && map.canAccess(i.x, i.y-1)) {
			var n3:Item = { x:i.x, y:i.y-1, distance:0, cost:i.cost+1 };
			n3.distance = distance(goal, n3);
			t.push(n3);
		}
		if(i.y < map.height - 1 && map.canAccess(i.x, i.y+1)) {
			var n4:Item = { x:i.x, y:i.y+1, distance:0, cost:i.cost+1 };
			n4.distance = distance(goal, n4);
			t.push(n4);
		}
		
		return t;
	}
}