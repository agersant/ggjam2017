io.stdout:setvbuf("no");
io.stderr:setvbuf("no");

love.conf = function(options)
	options.console = false;
	options.window.title = "Sparky And The Other Fish";
	options.window.width = 640;
	options.window.height = 720;
	options.window.resizable = false;
	options.window.msaa = 8;
	options.window.vsync = false;
	
	options.modules.audio = true;
	options.modules.event = true;
	options.modules.graphics = true;
	options.modules.image = true;
	options.modules.joystick = true;
	options.modules.keyboard = true;
	options.modules.math = true;
	options.modules.mouse = true;
	options.modules.physics = true;
	options.modules.sound = true;
	options.modules.system = true;
	options.modules.timer = true;
	options.modules.window = true;

	options.modules.touch = false;
	options.modules.video = false;
	options.modules.thread = false;	
end
