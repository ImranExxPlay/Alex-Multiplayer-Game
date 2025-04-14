extends Node

var peer = ENetMultiplayerPeer.new()
var port = 9999
var max_players = 8
var lobbies = {} # {lobby_id: {name, max_players, region, players, host}}

func _ready():
	var error = peer.create_server(port, max_players)
	if error != OK:
		print("Failed to start server: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", port)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id):
	print("Client connected: ", id)

func _on_peer_disconnected(id):
	print("Client disconnected: ", id)
	for lobby_id in lobbies.keys():
		if id in lobbies[lobby_id]["players"]:
			lobbies[lobby_id]["players"].erase(id)
			if lobbies[lobby_id]["players"].size() == 0:
				lobbies.erase(lobby_id)
			print("Updated lobbies: ", lobbies)

@rpc("any_peer", "call_local", "reliable")
func create_lobby(lobby_name, max_players, region, host_id):
	var lobby_id = lobbies.size() + 1
	lobbies[lobby_id] = {
		"name": lobby_name,
		"max_players": max_players,
		"region": region,
		"players": [host_id],
		"host": host_id
	}
	print("Lobby created: ", lobbies[lobby_id])
	rpc_id(host_id, "lobby_created", lobby_id)
