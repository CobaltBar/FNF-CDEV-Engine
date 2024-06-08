package game.cdev.log;

/**
 * Used for colored traces in Terminal
 * Written by Cobalt Bar - https://github.com/CobaltBar/FNF-Horizon-Engine/blob/main/source/util/Log.hx
 * Modified by CoreCat/Dev for use in CDEV Engine
 *
 * :3
 */
import haxe.Constraints.Function;
import haxe.PosInfos;

using StringTools;

enum abstract AnsiMode(Int)
{
	var RESET = 0;
	var BOLD = 1;
	var DIM = 2;
	var ITALIC = 3;
	var UNDERLINE = 4;
	var BLINKING = 5;
	var INVERT = 7;
	var INVISIBLE = 8;
	var STRIKETHROUGH = 9;
}

enum abstract AnsiColor(Int)
{
	var BLACK = 30;
	var RED = 31;
	var GREEN = 32;
	var YELLOW = 33;
	var BLUE = 34;
	var MAGENTA = 35;
	var CYAN = 36;
	var WHITE = 37;
	var HIGHINTENSITY_BLACK = 90;
	var HIGHINTENSITY_RED = 91;
	var HIGHINTENSITY_GREEN = 92;
	var HIGHINTENSITY_YELLOW = 93;
	var HIGHINTENSITY_BLUE = 94;
	var HIGHINTENSITY_MAGENTA = 95;
	var HIGHINTENSITY_CYAN = 96;
	var HIGHINTENSITY_WHITE = 97;
	var RESET = 0;
}

class TerminalLog
{
	// https://gist.github.com/martinwells/5980517
	// https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
	private static var ogTrace:Function;
	private static var log:String = "";

	/*
		if (!FileSystem.exists('log'))
			FileSystem.createDirectory('log');
		Log.info('Log Written');
		File.saveContent('log/log.txt', @:privateAccess Log.log);


		this saves the log to `log/log.txt`
	 */
	public static function init():Void
	{
		ogTrace = haxe.Log.trace;
		haxe.Log.trace = haxeTrace;
		prettyPrint("CDEV Engine v" + CDevConfig.engineVersion + "\n(Logging style written by CobaltBar!)");
		info('Logger Initialized');
	}

	@:keep public static inline function ansi(mode:AnsiMode, color:AnsiColor):String
		return '\033[${mode};${color}m';

	@:keep static inline function haxeTrace(value:Dynamic, ?pos:PosInfos):Void
		print(value, 'TRACE', BOLD, HIGHINTENSITY_BLUE, pos);

	@:keep public static inline function error(value:Dynamic, ?pos:PosInfos):Void
		print(value, 'ERROR', BOLD, RED, pos);

	@:keep public static inline function warn(value:Dynamic, ?pos:PosInfos):Void
		print(value, 'WARN', BOLD, YELLOW, pos);

	@:keep public static inline function info(value:Dynamic, ?pos:PosInfos):Void
		print(value, 'INFO', BOLD, CYAN, pos);

	@:keep public static inline function script(value:Dynamic, ?pos:PosInfos):Void
		print(value, 'SCRIPT', BOLD, MAGENTA, pos);

	@:keep static inline function print(value:Dynamic, level:String, mode:AnsiMode, color:AnsiColor, ?pos:PosInfos):Void
	{
		var msg:String = '${ansi(RESET, BLUE)}[${ansi(RESET, CYAN)}${DateTools.format(Date.now(), '%H:%M:%S')}';
		if (pos != null)
			msg += '${ansi(RESET, BLUE)} - ${ansi(BOLD, WHITE)}${pos.fileName.replace("source/", "")}:${pos.lineNumber}';
		msg += '${ansi(RESET, BLUE)}]';
		msg = (msg.rpad(' ', 90) + '${ansi(mode, color)}${level}: ').rpad(' ', 95) + '${ansi(RESET, color)}$value${ansi(RESET, RESET)}';
		Sys.println(msg);

		var logMsg:String = '[${DateTools.format(Date.now(), '%H:%M:%S')}';
		if (pos != null)
			logMsg += ' - ${pos.fileName}:${pos.lineNumber}';
		logMsg += '] ${level}: $value\n';
		log += logMsg;
	}

	public static function prettyPrint(text:String)
	{
		var lines = text.split("\n");
		var length = -1;
		for (line in lines)
			if (line.length > length)
				length = line.length;

		var header = "======";
		for (i in 0...length)
			header += "=";

		Sys.println("");
		Sys.println('|$header|');
		for (line in lines)
		{
			Sys.println('|   ${ansi(RESET, CYAN) + centerText(line, length) + ansi(RESET, WHITE)}   |');
		}
		Sys.println('|$header|');
	}

	public static function centerText(text:String, width:Int):String
	{
		var centerOffset = (width - text.length) / 2;
		var left = repeat(' ', Math.floor(centerOffset));
		var right = repeat(' ', Math.ceil(centerOffset));
		return left + text + right;
	}

	public static inline function repeat(ch:String, amt:Int)
	{
		var str = "";
		for (i in 0...amt)
			str += ch;
		return str;
	}
}
