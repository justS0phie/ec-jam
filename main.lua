math.randomseed(os.time())

love.filesystem.setRequirePath( 'MyLib/?.lua' )
require ('MyLib')

love.filesystem.setRequirePath( 'Scripts/?.lua' )
require ('1ove_draw')
require ('1ove_keypressed')
require ('1ove_update')

require ('Utils')
require ('Constants')

require ('DataManager')
require ('GameController')
require ('MainMenu')
require ('Map')
require ('Player')
require ('QueueManager')
require ('View')
require ('World')

MyLib.MyLibSetup()

DataManager.load_user_data()
GameController.begin_game()
love.graphics.setFont(Constants.FONT)