extends Control

@onready var lobby_name_input: LineEdit = $NameInput
@onready var players_dropdown: OptionButton = $PlayersDropdown
@onready var region_dropdown: OptionButton = $RegionDropdown
@onready var create_button: Button = $CreateButton

func _ready():
	create_button.pressed.connect(_on_create_button_pressed)
	
	players_dropdown.select(0)
	region_dropdown.select(0)

func _on_create_button_pressed():
	var lobby_name = lobby_name_input.text
	var max_players = int(players_dropdown.get_item_text(players_dropdown.selected))
	var region = region_dropdown.get_item_text(region_dropdown.selected)
	if lobby_name == "":
		print("Please enter a lobby name!")
		return
	if multiplayer.multiplayer_peer == null or multiplayer.multiplayer_peer.get_connection_status() != MultiplayerPeer.CONNECTION_CONNECTED:
		print("Not connected to server!")
		return
	# Send to server
	rpc_id(1, "create_lobby", lobby_name, max_players, region, multiplayer.get_unique_id())
	print("Requested lobby: ", lobby_name, ", ", max_players, " players, ", region)

@rpc("authority", "call_local", "reliable")
func lobby_created(lobby_id):
	print("Lobby created, ID: ", lobby_id)
	get_tree().change_scene_to_file("res://scenes/placeholder.tscn")
