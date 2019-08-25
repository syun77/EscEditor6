package;


import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#elseif (winrt)
			rootPath = "./";
			#elseif (sys && windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end

		}

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_pixelmplus12_regular_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy36:assets%2Fmusic%2Fmusic-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR0y33:assets%2Fimages%2Fpallee.asepriteR2i568R3y6:BINARYR5R7R6tgoR0y33:assets%2Fimages%2Fcommon%2Fok.pngR2i331R3y5:IMAGER5R9R6tgoR0y40:assets%2Fimages%2Fcommon%2Fnum_arrow.pngR2i783R3R10R5R11R6tgoR0y34:assets%2Fimages%2Fcommon%2Ftap.pngR2i4177R3R10R5R12R6tgoR0y36:assets%2Fimages%2Fcommon%2Farrow.pngR2i570R3R10R5R13R6tgoR0y42:assets%2Fimages%2Fcommon%2Fitem_button.pngR2i1533R3R10R5R14R6tgoR0y35:assets%2Fimages%2Fcommon%2Fback.pngR2i373R3R10R5R15R6tgoR0y36:assets%2Fimages%2Fcommon%2Fclose.pngR2i380R3R10R5R16R6tgoR0y32:assets%2Fimages%2Fitem%2F002.pngR2i716R3R10R5R17R6tgoR0y32:assets%2Fimages%2Fitem%2F016.pngR2i817R3R10R5R18R6tgoR0y32:assets%2Fimages%2Fitem%2F017.pngR2i614R3R10R5R19R6tgoR0y32:assets%2Fimages%2Fitem%2F003.pngR2i630R3R10R5R20R6tgoR0y32:assets%2Fimages%2Fitem%2F015.pngR2i492R3R10R5R21R6tgoR0y32:assets%2Fimages%2Fitem%2F001.pngR2i608R3R10R5R22R6tgoR0y32:assets%2Fimages%2Fitem%2F000.pngR2i442R3R10R5R23R6tgoR0y32:assets%2Fimages%2Fitem%2F014.pngR2i553R3R10R5R24R6tgoR0y32:assets%2Fimages%2Fitem%2F010.pngR2i839R3R10R5R25R6tgoR0y32:assets%2Fimages%2Fitem%2F004.pngR2i611R3R10R5R26R6tgoR0y32:assets%2Fimages%2Fitem%2F005.pngR2i754R3R10R5R27R6tgoR0y32:assets%2Fimages%2Fitem%2F011.pngR2i1215R3R10R5R28R6tgoR0y32:assets%2Fimages%2Fitem%2F007.pngR2i590R3R10R5R29R6tgoR0y32:assets%2Fimages%2Fitem%2F013.pngR2i974R3R10R5R30R6tgoR0y32:assets%2Fimages%2Fitem%2F012.pngR2i1323R3R10R5R31R6tgoR0y32:assets%2Fimages%2Fitem%2F006.pngR2i729R3R10R5R32R6tgoR0y32:assets%2Fimages%2Fitem%2F008.pngR2i927R3R10R5R33R6tgoR0y32:assets%2Fimages%2Fitem%2F009.pngR2i566R3R10R5R34R6tgoR0y45:assets%2Fimages%2Finputs%2F001%2Fpictures.pngR2i7001R3R10R5R35R6tgoR0y45:assets%2Fimages%2Finputs%2F003%2Fpictures.pngR2i1673R3R10R5R36R6tgoR0y45:assets%2Fimages%2Finputs%2F002%2Fpictures.pngR2i2285R3R10R5R37R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R38R6tgoR2i1274396R3y4:FONTy9:classNamey46:__ASSET__assets_fonts_pixelmplus12_regular_ttfR5y41:assets%2Ffonts%2FPixelMplus12-Regular.ttfR6tgoR0y34:assets%2Fdata%2Fscene007%2Fkey.pngR2i1254R3R10R5R43R6tgoR0y34:assets%2Fdata%2Fscene007%2F007.csvR2i269R3R4R5R44R6tgoR0y33:assets%2Fdata%2Fscene007%2Fbg.pngR2i22663R3R10R5R45R6tgoR0y37:assets%2Fdata%2Fscene001%2Finput1.pngR2i217R3R10R5R46R6tgoR0y37:assets%2Fdata%2Fscene001%2Finput2.pngR2i459R3R10R5R47R6tgoR0y35:assets%2Fdata%2Fscene001%2Fknob.pngR2i339R3R10R5R48R6tgoR0y38:assets%2Fdata%2Fscene001%2Fconnect.pngR2i250R3R10R5R49R6tgoR0y36:assets%2Fdata%2Fscene001%2Fcable.pngR2i492R3R10R5R50R6tgoR0y38:assets%2Fdata%2Fscene001%2Foutlet2.pngR2i209R3R10R5R51R6tgoR0y38:assets%2Fdata%2Fscene001%2Fadapter.pngR2i833R3R10R5R52R6tgoR0y38:assets%2Fdata%2Fscene001%2Foutlet1.pngR2i348R3R10R5R53R6tgoR0y38:assets%2Fdata%2Fscene001%2Funlock2.pngR2i1124R3R10R5R54R6tgoR0y37:assets%2Fdata%2Fscene001%2Funlock.pngR2i1652R3R10R5R55R6tgoR0y34:assets%2Fdata%2Fscene001%2F001.csvR2i1292R3R4R5R56R6tgoR0y36:assets%2Fdata%2Fscene001%2Ftable.pngR2i846R3R10R5R57R6tgoR0y38:assets%2Fdata%2Fscene001%2Fsticker.pngR2i1929R3R10R5R58R6tgoR0y33:assets%2Fdata%2Fscene001%2Fbg.pngR2i1812R3R10R5R59R6tgoR0y35:assets%2Fdata%2Fscene006%2Fknob.pngR2i340R3R10R5R60R6tgoR0y38:assets%2Fdata%2Fscene006%2Funlock2.pngR2i856R3R10R5R61R6tgoR0y37:assets%2Fdata%2Fscene006%2Funlock.pngR2i1650R3R10R5R62R6tgoR0y34:assets%2Fdata%2Fscene006%2F006.csvR2i425R3R4R5R63R6tgoR0y38:assets%2Fdata%2Fscene006%2Fsticker.pngR2i889R3R10R5R64R6tgoR0y33:assets%2Fdata%2Fscene006%2Fbg.pngR2i1812R3R10R5R65R6tgoR0y32:assets%2Fdata%2Fpallete.asepriteR2i568R3R8R5R66R6tgoR0y31:assets%2Fdata%2Fitem%2Fitem.csvR2i1339R3R4R5R67R6tgoR0y38:assets%2Fdata%2Fscene003%2Fdrawer2.pngR2i1198R3R10R5R68R6tgoR0y38:assets%2Fdata%2Fscene003%2Fdrawer1.pngR2i449R3R10R5R69R6tgoR0y37:assets%2Fdata%2Fscene003%2Fremote.pngR2i643R3R10R5R70R6tgoR0y42:assets%2Fdata%2Fscene003%2Ffloppy_disk.pngR2i729R3R10R5R71R6tgoR0y41:assets%2Fdata%2Fscene003%2Fflashlight.pngR2i590R3R10R5R72R6tgoR0y38:assets%2Fdata%2Fscene003%2Funlock2.pngR2i390R3R10R5R73R6tgoR0y37:assets%2Fdata%2Fscene003%2Funlock.pngR2i454R3R10R5R74R6tgoR0y34:assets%2Fdata%2Fscene003%2F003.csvR2i650R3R4R5R75R6tgoR0y38:assets%2Fdata%2Fscene003%2Fsticker.pngR2i507R3R10R5R76R6tgoR0y33:assets%2Fdata%2Fscene003%2Fbg.pngR2i3666R3R10R5R77R6tgoR0y37:assets%2Fdata%2Fscene004%2Fmagnet.pngR2i1665R3R10R5R78R6tgoR0y35:assets%2Fdata%2Fscene004%2Flock.pngR2i484R3R10R5R79R6tgoR0y36:assets%2Fdata%2Fscene004%2Fscope.pngR2i754R3R10R5R80R6tgoR0y35:assets%2Fdata%2Fscene004%2Fhole.pngR2i380R3R10R5R81R6tgoR0y38:assets%2Fdata%2Fscene004%2Funlock2.pngR2i391R3R10R5R82R6tgoR0y37:assets%2Fdata%2Fscene004%2Funlock.pngR2i454R3R10R5R83R6tgoR0y39:assets%2Fdata%2Fscene004%2Fsticker2.pngR2i1200R3R10R5R84R6tgoR0y38:assets%2Fdata%2Fscene004%2Fsticker.pngR2i457R3R10R5R85R6tgoR0y33:assets%2Fdata%2Fscene004%2Fbg.pngR2i1799R3R10R5R86R6tgoR0y34:assets%2Fdata%2Fscene004%2F004.csvR2i785R3R4R5R87R6tgoR0y36:assets%2Fdata%2Fscene005%2Faiueo.pngR2i4102R3R10R5R88R6tgoR0y35:assets%2Fdata%2Fscene005%2Flock.pngR2i481R3R10R5R89R6tgoR0y38:assets%2Fdata%2Fscene005%2Funlock2.pngR2i392R3R10R5R90R6tgoR0y37:assets%2Fdata%2Fscene005%2Funlock.pngR2i454R3R10R5R91R6tgoR0y35:assets%2Fdata%2Fscene005%2Frope.pngR2i4490R3R10R5R92R6tgoR0y34:assets%2Fdata%2Fscene005%2F005.csvR2i420R3R4R5R93R6tgoR0y33:assets%2Fdata%2Fscene005%2Fbg.pngR2i1960R3R10R5R94R6tgoR0y39:assets%2Fdata%2Fscene002%2Fjyukugo1.pngR2i1052R3R10R5R95R6tgoR0y34:assets%2Fdata%2Fscene002%2F002.csvR2i45R3R4R5R96R6tgoR0y39:assets%2Fdata%2Fscene002%2Fjyukugo2.pngR2i1029R3R10R5R97R6tgoR0y33:assets%2Fdata%2Fscene002%2Fbg.pngR2i1785R3R10R5R98R6tgoR0y22:source%2Fdat%2Fesc.cdbR2i16604R3R4R5R99R6tgoR2i39706R3y5:MUSICR5y28:flixel%2Fsounds%2Fflixel.mp3y9:pathGroupaR101y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i2114R3R100R5y26:flixel%2Fsounds%2Fbeep.mp3R102aR104y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i5794R3y5:SOUNDR5R105R102aR104R105hgoR2i33629R3R106R5R103R102aR101R103hgoR2i15744R3R39R40y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R39R40y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R10R5R111R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R10R5R112R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_pallee_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_ok_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_num_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_tap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_item_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_back_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_close_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_002_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_016_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_017_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_003_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_015_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_001_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_000_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_014_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_010_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_004_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_005_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_011_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_007_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_013_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_012_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_006_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_008_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_009_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_inputs_001_pictures_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_inputs_003_pictures_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_inputs_002_pictures_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus12_regular_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene007_key_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene007_007_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene007_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_knob_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_connect_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_cable_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_outlet2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_adapter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_outlet1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_unlock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_001_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_table_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene006_knob_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene006_unlock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene006_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene006_006_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene006_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene006_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_pallete_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_item_item_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_drawer2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_drawer1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_remote_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_floppy_disk_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_flashlight_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_unlock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_003_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_magnet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_lock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_scope_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_hole_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_unlock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_sticker2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_004_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_aiueo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_lock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_unlock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_rope_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_005_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_jyukugo1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_002_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_jyukugo2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__source_dat_esc_cdb extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/images/pallee.aseprite") @:noCompletion #if display private #end class __ASSET__assets_images_pallee_aseprite extends haxe.io.Bytes {}
@:keep @:image("assets/images/common/ok.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_ok_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/num_arrow.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_num_arrow_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/tap.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_tap_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/arrow.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_arrow_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/item_button.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_item_button_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/back.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_back_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/close.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_close_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/002.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_002_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/016.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_016_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/017.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_017_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/003.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_003_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/015.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_015_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/001.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_001_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/000.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_000_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/014.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_014_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/010.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_010_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/004.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_004_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/005.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_005_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/011.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_011_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/007.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_007_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/013.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_013_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/012.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_012_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/006.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_006_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/008.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_008_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/009.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_009_png extends lime.graphics.Image {}
@:keep @:image("assets/images/inputs/001/pictures.png") @:noCompletion #if display private #end class __ASSET__assets_images_inputs_001_pictures_png extends lime.graphics.Image {}
@:keep @:image("assets/images/inputs/003/pictures.png") @:noCompletion #if display private #end class __ASSET__assets_images_inputs_003_pictures_png extends lime.graphics.Image {}
@:keep @:image("assets/images/inputs/002/pictures.png") @:noCompletion #if display private #end class __ASSET__assets_images_inputs_002_pictures_png extends lime.graphics.Image {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/PixelMplus12-Regular.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus12_regular_ttf extends lime.text.Font {}
@:keep @:image("assets/data/scene007/key.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene007_key_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene007/007.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene007_007_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene007/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene007_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/input1.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input1_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/input2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/knob.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_knob_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/connect.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_connect_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/cable.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_cable_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/outlet2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_outlet2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/adapter.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_adapter_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/outlet1.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_outlet1_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/unlock2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_unlock2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_unlock_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene001/001.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_001_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene001/table.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_table_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_sticker_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene006/knob.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene006_knob_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene006/unlock2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene006_unlock2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene006/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene006_unlock_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene006/006.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene006_006_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene006/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene006_sticker_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene006/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene006_bg_png extends lime.graphics.Image {}
@:keep @:file("assets/data/pallete.aseprite") @:noCompletion #if display private #end class __ASSET__assets_data_pallete_aseprite extends haxe.io.Bytes {}
@:keep @:file("assets/data/item/item.csv") @:noCompletion #if display private #end class __ASSET__assets_data_item_item_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene003/drawer2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_drawer2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/drawer1.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_drawer1_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/remote.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_remote_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/floppy_disk.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_floppy_disk_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/flashlight.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_flashlight_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/unlock2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_unlock2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_unlock_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene003/003.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_003_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene003/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_sticker_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/magnet.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_magnet_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/lock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_lock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/scope.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_scope_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/hole.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_hole_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/unlock2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_unlock2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_unlock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/sticker2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_sticker2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_sticker_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_bg_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene004/004.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_004_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene005/aiueo.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_aiueo_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/lock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_lock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/unlock2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_unlock2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_unlock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/rope.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_rope_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene005/005.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_005_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene005/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/jyukugo1.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_jyukugo1_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene002/002.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_002_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene002/jyukugo2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_jyukugo2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_bg_png extends lime.graphics.Image {}
@:keep @:file("source/dat/esc.cdb") @:noCompletion #if display private #end class __ASSET__source_dat_esc_cdb extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,2/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,2/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,2/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,2/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/4,6,2/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/4,6,2/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_pixelmplus12_regular_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus12_regular_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/PixelMplus12-Regular"; #else ascender = 884; descender = -200; height = 1084; numGlyphs = 7253; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "PixelMplus12 Regular"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_fonts_pixelmplus12_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_pixelmplus12_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_pixelmplus12_regular_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_fonts_pixelmplus12_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_pixelmplus12_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_pixelmplus12_regular_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
