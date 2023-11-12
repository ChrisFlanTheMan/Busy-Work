extends Node

enum ControlType {
	Keyboard,
	Gamepad,
}

enum Action {
	Use,
	Back,
}

enum Axis {
	UpDown,
	LeftRight,
}

const KEYBOARD_MAPPING = {
	Action: {
		Action.Use: KEY_ENTER,
		Action.Back: KEY_ESCAPE,
	},
	Axis: {
		Axis.UpDown: {
			"negative": KEY_W,
			"positive": KEY_S,
		},
		Axis.LeftRight: {
			"negative": KEY_A,
			"positive": KEY_D,
		},
	}
}

const JOYPAD_MAPPING = {
	Action: {
		Action.Use: JOY_BUTTON_A,
		Action.Back: JOY_BUTTON_B,
	},
	Axis: {
		Axis.UpDown: JOY_AXIS_LEFT_Y,
		Axis.LeftRight: JOY_AXIS_LEFT_X,
	},
}

# All mappings are PlayerMapping
class PlayerMapping:
	var controlType: ControlType

# Keyboard is always wasd, so no further config
class KeyboardPlayerMapping extends PlayerMapping:
	func _init():
		controlType = ControlType.Keyboard

class GamepadPlayerMapping extends PlayerMapping:
	var deviceId: int

	func _init(device: int):
		controlType = ControlType.Gamepad
		deviceId = device

signal playerAdded(playerId: int)

const DEADZONE = 0.2
const MAX_PLAYERS := 4
var playerSlots: Array[PlayerMapping] = []
var joinable: bool = true

func is_action_pressed(playerId: int, action: Action) -> bool:
	# assert(playerId < len(playerSlots), "PlayerId %s >= len(playerSlots)")
	if not playerId < len(playerSlots):
		return false
	var playerMap = playerSlots[playerId]

	if (playerMap is KeyboardPlayerMapping and KEYBOARD_MAPPING[Action].has(action)):
		return Input.is_key_pressed(KEYBOARD_MAPPING[Action][action])

	if (playerMap is GamepadPlayerMapping and JOYPAD_MAPPING[Action].has(action)):
		return Input.is_joy_button_pressed(playerMap.deviceId, JOYPAD_MAPPING[Action][action])

	return false

func getAxis(playerId: int, axis: Axis) -> float:
	# assert(playerId < len(playerSlots), "PlayerId %s >= len(playerSlots)")
	if not playerId < len(playerSlots):
		return 0
	var playerMap = playerSlots[playerId]

	if (playerMap is KeyboardPlayerMapping and KEYBOARD_MAPPING[Axis].has(axis)):
		var kbAxis = KEYBOARD_MAPPING[Axis][axis]
		var output = 0
		if Input.is_key_pressed(kbAxis["positive"]):
			output += 1
		if Input.is_key_pressed(kbAxis["negative"]):
			output -= 1
		return output

	if (playerMap is GamepadPlayerMapping and JOYPAD_MAPPING[Axis].has(axis)):
		var axisAmount = Input.get_joy_axis(playerMap.deviceId, JOYPAD_MAPPING[Axis][axis])
		if (abs(axisAmount) < DEADZONE):
			return 0
		else:
			return axisAmount

	return 0

func getMovementDir(playerId: int) -> Vector2:
	var upDown = getAxis(playerId, Axis.UpDown)
	var leftRight = getAxis(playerId, Axis.LeftRight)
	var movement = Vector2(leftRight, upDown)
	if (movement.length_squared() > 1):
		return movement.normalized()
	else:
		return movement

func _unhandled_input(event):
	if joinable && len(playerSlots) < MAX_PLAYERS:
		if event is InputEventKey:
			# add new keyboard player
			var hasKbPlayer = false
			for playerMapping in playerSlots:
				if playerMapping is KeyboardPlayerMapping:
					hasKbPlayer = true
			if not hasKbPlayer:
				playerSlots.push_back(KeyboardPlayerMapping.new())
				playerAdded.emit(len(playerSlots) - 1)
		if event is InputEventJoypadButton:
			# add new joypad player
			var hasDevicePlayer = false
			for playerMapping in playerSlots:
				if playerMapping is GamepadPlayerMapping:
					if playerMapping.deviceId == event.device:
						hasDevicePlayer = true
			if not hasDevicePlayer:
				playerSlots.push_back(GamepadPlayerMapping.new(event.device))
				playerAdded.emit(len(playerSlots) - 1)
