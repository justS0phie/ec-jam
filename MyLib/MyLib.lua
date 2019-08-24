MyLib = {}

require ('ScreenFade')
--[[ 

MyLib.FadeToColor(Time, Variables, Values, Type, {R,G,B,A}, Mirror)
*Makes the screen fade to a set color.

*Time (float) - Duration of the Fade, in seconds
*Variables (list) - List of variable Names (strings) to change Value after the fade ends
(CAUTION: THESE VARIABLES MUST BE IN THE love.update SCOPE)
*Values (list) - List of Values to change the variables to (in the same order)
*Type (string) - Fade type ("fill", "circle")
*Color ({float,float,float,float}) - The color of the Fading (Red, Green, Blue, Alpha)
*Mirror (boolean) - If true, MyLib.FadeToColor will Fade in and out, if false, only out.

MyLib.FadeImg(Time, Variables, Values, InOut, Img, X, Y)
*Makes the image Fade In/Out

*Time (float) - Duration of the Fade, in seconds
*InOut (boolean) - If true, fade in the Image, if false, fade it out
*Img (Img) - The Image to fade

MyLib.ApplyFades(dt)
*Updates all current Faders.

MyLib.DrawFades()
*Draws all the current Fades.

]]--

require ('KeyPressed')
--[[ 

global MyLib.key_list

MyLib.KeyPress(btn)
*returns a table with variables {btn, confirm, escape, up, down, left, right}

*Key is the pressed key
*Confirm is either enter, space or Z
*Cancel is Esc
*Directions are either arrows or WASD

MyLib.KeyRefresh()
*clears all keyboard variables (Uses MyLib.key_list). Put on end of love.update

MyLib.IsKeyDown()
*Calls love.keyboard.isDown(), but checking also MyLib.lock_controls

]]--

--#######################################--

require ('MyLibSetup')
--[[ 

function MyLib.MyLibSetup()
*sets up all function overrides needed to MyLib
*call in the end of main.lua

]]--

--#######################################--