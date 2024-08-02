class_name PankuModuleVariableTracker extends PankuModule

# The current scene root node, which will be updated automatically when the scene changes.
# current scene node was determined by node tree index at the beginning.
var _current_scene_root:Node
var _current_scene_index := 0
var _tween_loop:Tween

func init_module():
	_current_scene_index = core.get_tree().root.get_child_count() - 1
	await core.get_tree().process_frame
	setup_scene_root_tracker()
	setup_autoload_tracker()
	print_to_interactive_shell_window()

func update_module(delta:float):
	pass

# always register the current scene root as `current`
func setup_scene_root_tracker():
	_current_scene_root = get_game_root()
	core.gd_exprenv.register_env("Game", get_game_root())
	#core.gd_exprenv.register_env("Player", get_current_player())
	#core.gd_exprenv.register_env("Level", get_current_level())
	#core.gd_exprenv.register_env("Settings", get_settings())
	
	# INF LOOP WHEN UPDATING STATES?! IONO
	#core.gd_exprenv.register_env("Player", get_current_player())
	#core.gd_exprenv.register_env("Level", get_current_level())
	#core.gd_exprenv.register_env("Settings", get_settings())
	#_tween_loop = core.create_tween()
	#_tween_loop.set_loops().tween_callback(
	#	func(): 
	#		var r = get_game_root()
	#		if r != _current_scene_root:
	#			_current_scene_root = r
	#			core.gd_exprenv.register_env("Game", _current_scene_root)
	#			core.gd_exprenv.register_env("Player", get_current_player())
	#			core.gd_exprenv.register_env("Level", get_current_level())
	#			core.gd_exprenv.register_env("Settings", get_settings())
	#).set_delay(0.1)

func get_game_root() -> Node:
	return Game

func get_current_player() -> Node:
	return Game.GetCurrentPlayerActor()

func get_current_level() -> Node:
	return Game.GetLevel()

func get_settings() -> GameSettings:
	return Game.GetSettings()

func setup_autoload_tracker():
	# read root children, the last child is considered as scene node while others are autoloads.
	var root:Node = core.get_tree().root
	for i in range(root.get_child_count() - 1):
		if root.get_child(i).name == core.SingletonName:
			# skip the plugin singleton
			continue
		# register user singletons
		var user_singleton:Node = root.get_child(i)
		core.gd_exprenv.register_env(user_singleton.name, user_singleton)

func print_to_interactive_shell_window():
	pass
	# print a tip to interacvite_shell module
	# modules load order matters
	#var tip:String = "\n[tip] Game Commands Start With [b]Game[/b]"
	#if core.module_manager.has_module("interactive_shell"):
	#	var ishell = core.module_manager.get_module("interactive_shell")
	#	ishell.interactive_shell.output(tip)
