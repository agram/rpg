typedef Item = {
	x:Int,
	y:Int,
}

class Path
{
	var currentMap:Maps;
	var matrix:Array<Array<Int>> ;
	var tabResult:Array<Array<Item>> ;
	var x:Int;
	var y:Int;
	public var retour:Item;
	var numero:Int;
	
	public function new(startX, startY, goalX, goalY) {
		currentMap = Game.inst.currentMap;
		numero = 0;
		matrix = [];
		
		for (i in 0...currentMap.width) {
			matrix[i] = [];
			for (j in 0...currentMap.height)
				matrix[i][j] = -1;
		}
		
		x = startX;
		y = startY;
		
		retour = { x: -1, y: -1 };
		
		matrix[x][y] = numero++;
		tabResult = [];
		tabResult[numero] = [];
		tabResult[numero].push( { x:x, y:y });
		var next = true;
		while (tabResult[numero].length > 0) {
			numero++;
			tabResult[numero] = [];
			for (t in tabResult[numero - 1]) {
				if (!searchNeighbors(t.x, t.y, numero, goalX, goalY) ) return;
			}
		}	
	}
	
	function searchNeighbors(x, y, n, goalX, goalY) {
		if (x > 0 && currentMap.canAccess(x - 1, y) && matrix[x-1][y] == -1) {
			matrix[x - 1][y] = numero;
			tabResult[numero].push( { x:x - 1, y:y } );
			if (x - 1 == goalX && y == goalY) {
				retour = { x:x, y:y };
				return false;
			}
		}
		if (x < currentMap.width - 1 && currentMap.canAccess(x + 1, y) && matrix[x+1][y] == -1) {
			matrix[x + 1][y] = numero;
			tabResult[numero].push( { x:x+1, y:y} );
			if (x + 1 == goalX && y == goalY) {
				retour = { x:x, y:y };
				return false;
			}
		}
		if (y > 0 && currentMap.canAccess(x, y - 1) && matrix[x][y - 1] == -1) {
			matrix[x][y - 1] = numero;
			tabResult[numero].push( { x:x, y:y - 1} );
			if (x == goalX && y - 1 == goalY) {
				retour = { x:x, y:y };
				return false;
			}
		}
		if (y < currentMap.height - 1 && currentMap.canAccess(x, y + 1) && matrix[x][y + 1] == -1) {
			matrix[x][y + 1] = numero;
			tabResult[numero].push( { x:x, y:y + 1} );
			if (x == goalX && y + 1 == goalY) {
				retour = { x:x, y:y };
				return false;
			}
		}

		return true;
	}
	
}