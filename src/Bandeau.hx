class Bandeau extends h2d.ScaleGrid
{
	public var tempsO:Int;
	public var tempsC:Int;
	static var TIME = 10;
	var game:Game;
	public var texte:h2d.Text;
	
	var listeMessage:Array<String>;
	
	public function new(t) 
	{
		game = Game.inst;
		super(t, 8, 8);
		visible = false;
		colorKey = 0xFFFFFFFF;
		width = (Const.GAME_WIDTH - 2) * Const.TILE_SIZE;
		height = 48;
		tempsO = -1;
		tempsC = -1;
		scaleX = 0;
		
		var font = Res.Minecraftia.build(8, { antiAliasing : false } );
		texte = new h2d.Text(font);
		texte.x = 8;
		texte.y = 8;
		this.addChild(texte);

		listeMessage = [];

	}
	
	public function close() {
		if(tempsC == -1 && tempsO == -1) {
			tempsC = TIME;
			tempsO = -1;
		}

		return listeMessage.length == 0;
	}
	
	public function update() {
		if (tempsC > 0) {
			tempsC--;
			scaleX = tempsC / TIME;
		}			
		if(tempsC == 0) {
			visible = false;
			scaleX = 0;
			openA(listeMessage);
		}
		if (tempsO > 0) {
			tempsO--;
			scaleX = (TIME-tempsO) / TIME;
		}			
		if(tempsO == 0) {
			tempsO = -1;
		}
	}
	
	public function openA(tab:Array<String>) {
		if (tab.length > 0) {
			open(tab.shift());
			listeMessage = tab;
		}
	}
	
	public function open(t:String) {
		if (scaleX == 1) close();
		else {
			x = Const.TILE_SIZE;
			if (Hero.inst.posY < 8)
				y = (Const.GAME_HEIGHT - 7) * Const.TILE_SIZE;
			else 
				y = 8;
			visible = true;
			tempsO = TIME;
			tempsC = -1;
			texte.text = t;
		}
	}
	
	public function tuto() {
		openA([
		"Tutoriel des commandes",
		"Fleches directionnelles \npour se déplacer",
		'Espace pour tenter \nune action',
		'Q pour connaître \nles quêtes actuelles',
		'H pour relancer \nce tuto',
		'Bonne chance !',
		]);
	}
	
	public function currentQuest() {
		openA(Hero.inst.quests.currentQuest());	
	}

	public function clearMessage() {
		listeMessage = [];
	}
}