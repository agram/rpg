class Title extends hxd.App {

	override function init() {
		s2d.setFixedSize(Const.WIDTH, Const.HEIGHT);
		var bmp = new h2d.Bitmap(Res.title.toTile());
		s2d.add(bmp, 100);
		
		var font = Res.Minecraftia.build(8,{ antiAliasing : false });		
		var tf = new h2d.Text(font, bmp);
		tf.text = "Click to start";
		tf.color = new h3d.Vector(1, 0, 0);
		tf.x = 10;
		tf.y = 15;
		tf.dropShadow = { dx : 1, dy : 1, color : 0, alpha : 0.8 };
		
		var i = new h2d.Interactive(s2d.width, s2d.height, bmp);
		i.cursor = Default;
		i.onRelease = function(_) {
			tf.remove();
			bmp.remove();
			i.remove();
			Game.inst = new Game(engine);
		};
		
		engine.render(s2d);
	}
	
	public static var inst : Title;	
	public static function main() {	
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,{compressSounds:true}));
		inst = new Title();
	}
	
	
}