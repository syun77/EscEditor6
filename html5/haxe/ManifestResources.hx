package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
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
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_pixelmplus10_regular_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy36:assets%2Fmusic%2Fmusic-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR0y33:assets%2Fimages%2Fpallee.asepriteR2i568R3y6:BINARYR5R7R6tgoR0y33:assets%2Fimages%2Fcommon%2Fok.pngR2i331R3y5:IMAGER5R9R6tgoR0y40:assets%2Fimages%2Fcommon%2Fnum_arrow.pngR2i735R3R10R5R11R6tgoR0y34:assets%2Fimages%2Fcommon%2Ftap.pngR2i4177R3R10R5R12R6tgoR0y36:assets%2Fimages%2Fcommon%2Farrow.pngR2i570R3R10R5R13R6tgoR0y33:assets%2Fimages%2Fcommon%2Fpf.pngR2i433R3R10R5R14R6tgoR0y36:assets%2Fimages%2Fcommon%2Fpanel.pngR2i248R3R10R5R15R6tgoR0y42:assets%2Fimages%2Fcommon%2Fitem_button.pngR2i1533R3R10R5R16R6tgoR0y35:assets%2Fimages%2Fcommon%2Fstar.pngR2i246R3R10R5R17R6tgoR0y35:assets%2Fimages%2Fcommon%2Fback.pngR2i373R3R10R5R18R6tgoR0y36:assets%2Fimages%2Fcommon%2Fclose.pngR2i380R3R10R5R19R6tgoR0y38:assets%2Fimages%2Fadv%2Fobjs%2F002.pngR2i1786R3R10R5R20R6tgoR0y38:assets%2Fimages%2Fadv%2Fobjs%2F003.pngR2i1884R3R10R5R21R6tgoR0y38:assets%2Fimages%2Fadv%2Fobjs%2F001.pngR2i700R3R10R5R22R6tgoR0y38:assets%2Fimages%2Fadv%2Fobjs%2F004.pngR2i1868R3R10R5R23R6tgoR0y38:assets%2Fimages%2Fadv%2Fobjs%2F005.pngR2i1914R3R10R5R24R6tgoR0y40:assets%2Fimages%2Fadv%2Fobjs%2Fframe.pngR2i1355R3R10R5R25R6tgoR0y32:assets%2Fimages%2Fitem%2F002.pngR2i545R3R10R5R26R6tgoR0y32:assets%2Fimages%2Fitem%2F003.pngR2i679R3R10R5R27R6tgoR0y32:assets%2Fimages%2Fitem%2F001.pngR2i642R3R10R5R28R6tgoR0y32:assets%2Fimages%2Fitem%2F000.pngR2i442R3R10R5R29R6tgoR0y32:assets%2Fimages%2Fitem%2F010.pngR2i597R3R10R5R30R6tgoR0y32:assets%2Fimages%2Fitem%2F004.pngR2i646R3R10R5R31R6tgoR0y32:assets%2Fimages%2Fitem%2F005.pngR2i541R3R10R5R32R6tgoR0y32:assets%2Fimages%2Fitem%2F011.pngR2i710R3R10R5R33R6tgoR0y32:assets%2Fimages%2Fitem%2F007.pngR2i1215R3R10R5R34R6tgoR0y32:assets%2Fimages%2Fitem%2F013.pngR2i617R3R10R5R35R6tgoR0y32:assets%2Fimages%2Fitem%2F012.pngR2i744R3R10R5R36R6tgoR0y32:assets%2Fimages%2Fitem%2F006.pngR2i858R3R10R5R37R6tgoR0y32:assets%2Fimages%2Fitem%2F008.pngR2i629R3R10R5R38R6tgoR0y32:assets%2Fimages%2Fitem%2F009.pngR2i734R3R10R5R39R6tgoR0y45:assets%2Fimages%2Finputs%2F001%2Fpictures.pngR2i3729R3R10R5R40R6tgoR0y45:assets%2Fimages%2Finputs%2F003%2Fpictures.pngR2i6907R3R10R5R41R6tgoR0y45:assets%2Fimages%2Finputs%2F002%2Fpictures.pngR2i1809R3R10R5R42R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R43R6tgoR2i1133216R3y4:FONTy9:classNamey46:__ASSET__assets_fonts_pixelmplus10_regular_ttfR5y41:assets%2Ffonts%2FPixelMplus10-Regular.ttfR6tgoR0y37:assets%2Fdata%2Fscene001%2Finput2.pngR2i346R3R10R5R48R6tgoR0y36:assets%2Fdata%2Fscene001%2Finput.pngR2i309R3R10R5R49R6tgoR0y37:assets%2Fdata%2Fscene001%2Funlock.pngR2i681R3R10R5R50R6tgoR0y36:assets%2Fdata%2Fscene001%2Fknife.pngR2i1069R3R10R5R51R6tgoR0y34:assets%2Fdata%2Fscene001%2F001.csvR2i812R3R4R5R52R6tgoR0y38:assets%2Fdata%2Fscene001%2Fsticker.pngR2i1871R3R10R5R53R6tgoR0y33:assets%2Fdata%2Fscene001%2Fbg.pngR2i4033R3R10R5R54R6tgoR0y32:assets%2Fdata%2Fpallete.asepriteR2i568R3R8R5R55R6tgoR0y31:assets%2Fdata%2Fitem%2Fitem.csvR2i1108R3R4R5R56R6tgoR0y36:assets%2Fdata%2Fscene003%2Fwolf2.pngR2i703R3R10R5R57R6tgoR0y36:assets%2Fdata%2Fscene003%2Fwolf1.pngR2i626R3R10R5R58R6tgoR0y37:assets%2Fdata%2Fscene003%2Fdriver.pngR2i932R3R10R5R59R6tgoR0y36:assets%2Fdata%2Fscene003%2Fclock.pngR2i90R3R10R5R60R6tgoR0y37:assets%2Fdata%2Fscene003%2Funlock.pngR2i151R3R10R5R61R6tgoR0y35:assets%2Fdata%2Fscene003%2Firon.pngR2i617R3R10R5R62R6tgoR0y34:assets%2Fdata%2Fscene003%2F003.csvR2i1749R3R4R5R63R6tgoR0y33:assets%2Fdata%2Fscene003%2Fbg.pngR2i2151R3R10R5R64R6tgoR0y36:assets%2Fdata%2Fscene004%2Fblood.pngR2i651R3R10R5R65R6tgoR0y35:assets%2Fdata%2Fscene004%2Fmemo.pngR2i202R3R10R5R66R6tgoR0y36:assets%2Fdata%2Fscene004%2Fphone.pngR2i1173R3R10R5R67R6tgoR0y37:assets%2Fdata%2Fscene004%2Fbucket.pngR2i432R3R10R5R68R6tgoR0y36:assets%2Fdata%2Fscene004%2Fshelf.pngR2i601R3R10R5R69R6tgoR0y37:assets%2Fdata%2Fscene004%2Fshelf2.pngR2i332R3R10R5R70R6tgoR0y33:assets%2Fdata%2Fscene004%2Fbg.pngR2i5551R3R10R5R71R6tgoR0y34:assets%2Fdata%2Fscene004%2F004.csvR2i1325R3R4R5R72R6tgoR0y36:assets%2Fdata%2Fscene005%2Fstick.pngR2i829R3R10R5R73R6tgoR0y36:assets%2Fdata%2Fscene005%2Fchair.pngR2i560R3R10R5R74R6tgoR0y36:assets%2Fdata%2Fscene005%2Finput.pngR2i299R3R10R5R75R6tgoR0y39:assets%2Fdata%2Fscene005%2Fsticker2.pngR2i536R3R10R5R76R6tgoR0y38:assets%2Fdata%2Fscene005%2Fsticker.pngR2i405R3R10R5R77R6tgoR0y34:assets%2Fdata%2Fscene005%2F005.csvR2i583R3R4R5R78R6tgoR0y33:assets%2Fdata%2Fscene005%2Fbg.pngR2i3124R3R10R5R79R6tgoR0y35:assets%2Fdata%2Fscene002%2Fmemo.pngR2i197R3R10R5R80R6tgoR0y39:assets%2Fdata%2Fscene002%2Fsticker2.pngR2i684R3R10R5R81R6tgoR0y34:assets%2Fdata%2Fscene002%2F002.csvR2i383R3R4R5R82R6tgoR0y36:assets%2Fdata%2Fscene002%2Fdust2.pngR2i281R3R10R5R83R6tgoR0y38:assets%2Fdata%2Fscene002%2Fsticker.pngR2i576R3R10R5R84R6tgoR0y36:assets%2Fdata%2Fscene002%2Fdust1.pngR2i312R3R10R5R85R6tgoR0y33:assets%2Fdata%2Fscene002%2Fbg.pngR2i1860R3R10R5R86R6tgoR0y22:source%2Fdat%2Fesc.cdbR2i18062R3R4R5R87R6tgoR2i39706R3y5:MUSICR5y28:flixel%2Fsounds%2Fflixel.mp3y9:pathGroupaR89y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i2114R3R88R5y26:flixel%2Fsounds%2Fbeep.mp3R90aR92y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i5794R3y5:SOUNDR5R93R90aR92R93hgoR2i33629R3R94R5R91R90aR89R91hgoR2i15744R3R44R45y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R44R45y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R10R5R99R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R10R5R100R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_pf_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_panel_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_item_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_star_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_back_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_common_close_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_002_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_003_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_001_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_004_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_005_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_frame_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_002_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_003_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_001_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_item_000_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus10_regular_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_knife_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_001_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene001_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_pallete_aseprite extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_item_item_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_wolf2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_wolf1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_driver_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_clock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_unlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_iron_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_003_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene003_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_blood_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_memo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_phone_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_bucket_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_shelf_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_shelf2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene004_004_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_stick_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_chair_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_input_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_sticker2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_005_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene005_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_memo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_sticker2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_002_csv extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_dust2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_sticker_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_scene002_dust1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
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
@:keep @:image("assets/images/common/pf.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_pf_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/panel.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_panel_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/item_button.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_item_button_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/star.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_star_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/back.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_back_png extends lime.graphics.Image {}
@:keep @:image("assets/images/common/close.png") @:noCompletion #if display private #end class __ASSET__assets_images_common_close_png extends lime.graphics.Image {}
@:keep @:image("assets/images/adv/objs/002.png") @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_002_png extends lime.graphics.Image {}
@:keep @:image("assets/images/adv/objs/003.png") @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_003_png extends lime.graphics.Image {}
@:keep @:image("assets/images/adv/objs/001.png") @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_001_png extends lime.graphics.Image {}
@:keep @:image("assets/images/adv/objs/004.png") @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_004_png extends lime.graphics.Image {}
@:keep @:image("assets/images/adv/objs/005.png") @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_005_png extends lime.graphics.Image {}
@:keep @:image("assets/images/adv/objs/frame.png") @:noCompletion #if display private #end class __ASSET__assets_images_adv_objs_frame_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/002.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_002_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/003.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_003_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/001.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_001_png extends lime.graphics.Image {}
@:keep @:image("assets/images/item/000.png") @:noCompletion #if display private #end class __ASSET__assets_images_item_000_png extends lime.graphics.Image {}
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
@:keep @:font("export/html5/obj/webfont/PixelMplus10-Regular.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus10_regular_ttf extends lime.text.Font {}
@:keep @:image("assets/data/scene001/input2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/input.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_input_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_unlock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/knife.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_knife_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene001/001.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_001_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene001/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_sticker_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene001/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene001_bg_png extends lime.graphics.Image {}
@:keep @:file("assets/data/pallete.aseprite") @:noCompletion #if display private #end class __ASSET__assets_data_pallete_aseprite extends haxe.io.Bytes {}
@:keep @:file("assets/data/item/item.csv") @:noCompletion #if display private #end class __ASSET__assets_data_item_item_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene003/wolf2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_wolf2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/wolf1.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_wolf1_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/driver.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_driver_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/clock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_clock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/unlock.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_unlock_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene003/iron.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_iron_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene003/003.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_003_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene003/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene003_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/blood.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_blood_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/memo.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_memo_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/phone.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_phone_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/bucket.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_bucket_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/shelf.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_shelf_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/shelf2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_shelf2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene004/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_bg_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene004/004.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene004_004_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene005/stick.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_stick_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/chair.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_chair_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/input.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_input_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/sticker2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_sticker2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene005/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_sticker_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene005/005.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_005_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene005/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene005_bg_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/memo.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_memo_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/sticker2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_sticker2_png extends lime.graphics.Image {}
@:keep @:file("assets/data/scene002/002.csv") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_002_csv extends haxe.io.Bytes {}
@:keep @:image("assets/data/scene002/dust2.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_dust2_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/sticker.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_sticker_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/dust1.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_dust1_png extends lime.graphics.Image {}
@:keep @:image("assets/data/scene002/bg.png") @:noCompletion #if display private #end class __ASSET__assets_data_scene002_bg_png extends lime.graphics.Image {}
@:keep @:file("source/dat/esc.cdb") @:noCompletion #if display private #end class __ASSET__source_dat_esc_cdb extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,3/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,3/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,3/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("/usr/local/lib/haxe/lib/flixel/4,6,3/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/4,6,3/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/usr/local/lib/haxe/lib/flixel/4,6,3/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_pixelmplus10_regular_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus10_regular_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/PixelMplus10-Regular"; #else ascender = 900; descender = -200; height = 1100; numGlyphs = 7253; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "PixelMplus10 Regular"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_fonts_pixelmplus10_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_pixelmplus10_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_pixelmplus10_regular_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_fonts_pixelmplus10_regular_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_pixelmplus10_regular_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_pixelmplus10_regular_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
