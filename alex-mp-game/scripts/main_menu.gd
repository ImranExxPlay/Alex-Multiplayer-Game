extends Control

var peer = ENetMultiplayerPeer.new()
var server_address = "127.0.0.1" # Localhost
var server_port = 9999
@onready var host_btn: Button = $Host
@onready var join_btn: Button = $Join
var is_host = false

func _ready():
	host_btn.pressed.connect(_on_host_button_pressed)
	join_btn.pressed.connect(_on_join_button_pressed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_host_button_pressed():
	var error = peer.create_client(server_address, server_port)
	if error != OK:
		print("Failed to connect: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Connecting to server for hosting...")
	is_host = true

func _on_join_button_pressed():
	var error = peer.create_client(server_address, server_port)
	if error != OK:
		print("Failed to connect: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Connecting to server...")

func _on_connected_to_server():
	print("Successfully connected to server!")
	if is_host:
		get_tree().change_scene_to_file("res://scenes/create_lobby.tscn")
	else:
		print("Join path not implemented yet")

func _on_connection_failed():
	print("Connection failed!")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	print("Disconnected from server!")
	multiplayer.multiplayer_peer = null
