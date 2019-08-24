dialog = {
	{GameController.player, '...'},
	{GameController.player, 'what is this?'},
}

return {
	function ()
		Event.start_dialog(dialog)
	end
}