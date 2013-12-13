typedef Quete = {
	code: QuestName,
	texte: String,
	current: Bool,
	clear: Bool,
	next: QuestName,
	success: String,
}

enum QuestName {
	NONE; 
	
	CARRE;
	CROIX;
	TRIANGLE;
	ROND;
	
	VILLAGE;
	MAISON;
	BOIS;
	MONTAGNE;
	
	WIN;
}


//enum Goal {
	//Carre( m : Monster, count : Int );
	//Get( i : Item );
	//And( g1 : Goal, g2 : Goal );
	//Or( g1 : Goal, g2 : Goal );
//}

class Quests
{
	var all:Array<QuestName>;
	public var tabQuests : Map<QuestName, Quete>;
	
	public function new () {
		
		all = QuestName.createAll();
		var allTexte = loadTexte();
		var allNext = loadNext();
		var allSuccess = loadSuccess();
		tabQuests = [for ( a in all ) a => { code:a, texte:allTexte[a], current:false, clear:false, next: allNext[a], success: allSuccess[a]} ];
		tabQuests[CARRE].current = true;
	}
	
	public function currentQuest() {
		var tab = [];
		return [for (a in tabQuests) if (a.current) a.texte];
	}
	
	function loadNext() {
		return [
			CARRE => CROIX,
			CROIX => TRIANGLE,
			TRIANGLE => ROND,
			ROND => VILLAGE,
			
			VILLAGE => MAISON,
			MAISON => BOIS,
			BOIS => MONTAGNE,
			MONTAGNE => WIN,
			
			WIN => NONE,
			NONE => NONE,
		];
	}
	
	function loadTexte() {
		return [
			CROIX => "Trouve le trésor \nau centre de la croix",
			ROND => "Trouve le trésor \nau centre du rond",
			CARRE => "Trouve le trésor \nau centre du carre",
			TRIANGLE => "Trouve le trésor \nen haut du triangle",
			
			MONTAGNE => "Trouve le trésor \ndans la montagne",
			MAISON => "Trouve le trésor \ndans la maison inaccessible",
			BOIS => "Trouve le trésor \ndans le bois mystérieux",
			VILLAGE => "Trouve le trésor \ndans une bouche",
			
			WIN => "Félicitation ! Tu as trouvé \ntous les trésors ! ",
			NONE => "",
		];
	}
	
	function loadSuccess() {
		return [
			CROIX => "Bravo ! Tu as trouve \nle trésor de la croix",
			ROND => "Bravo ! Tu as trouve \nle trésor du rond",
			CARRE => "Bravo ! Tu as trouve \nle trésor du carre",
			TRIANGLE => "Bravo ! Tu as trouve \nle trésor du triangle",
			
			MONTAGNE => "Bravo ! Tu as trouve \nle trésor de la montagne",
			MAISON => "Bravo ! Tu as trouve \nle trésor de la maison",
			BOIS => "Bravo ! tu as trouve \nle trésor du bois",
			VILLAGE => "Bravo ! Tu as trouve le trésor \ndans une bouche",
			
			WIN => "",
			NONE => "",
		];
	}
	
	public function validate(code:QuestName) {
		var current = tabQuests[code];
		var next = tabQuests[current.next];
		
		if (!current.current) return false;
		
		hxd.Res.item8b.play();
		current.current = false;
		next.current = true;
		Game.inst.bandeau.openA([current.success, next.texte]);
		
		return true;
	}
}