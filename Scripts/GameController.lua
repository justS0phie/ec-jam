GameController = {}
GameController.__index = GameController

function GameController.begin_game()
	GameController.go_to_main_menu()
end

function GameController.go_to_main_menu()
	GameController.state = Constants.EnumGameState.MENU
	GameController.menu = MainMenu.new()
	DataManager.load_files()
end

function GameController.start_new_game()
	GameController.menu = nil
	GameController.state = Constants.EnumGameState.IN_GAME
	GameController.world = World.new()
	GameController.player = Player.new()
	GameController.world:load_map(2)
end

function GameController.next_level()
	GameController.world:load_map(GameController.level_no + 1)
end
