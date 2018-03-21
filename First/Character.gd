extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera
var anim_player
var character

const SPEED = 2
const ACCELERATION = 1
const DE_ACCELERATION = 2

func _ready():

	
	anim_player = get_node("AnimationPlayer")
	character = get_node(".")

#func _process(delta):
#	pass

func _physics_process(delta):
	camera = get_node("Target/Camera").get_global_transform()
	var dir = Vector3()
	var is_moving = false
	
	#CONTROLS
	if (Input.is_action_pressed("move_fw")):
		dir += -camera.basis[2]
		is_moving = true
	if (Input.is_action_pressed("move_bw")):
		dir += camera.basis[2]
		is_moving = true
	if (Input.is_action_pressed("move_l")):
		dir += -camera.basis[0]
		is_moving = true
	if (Input.is_action_pressed("move_r")):
		dir += camera.basis[0]
		is_moving = true
		
		
	dir.y = 0 
	dir = dir.normalized()
	
	velocity.y +=  delta * gravity
	
	var hv = velocity 
	hv.y = 0  
	
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION

	if (dir.dot(hv) > 0):
		accel = ACCELERATION


	hv = hv.linear_interpolate(new_pos, accel * delta)

	velocity.x = hv.x
	velocity.z = hv.z
	
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving:
		
		var angle = atan2(hv.x, hv.z)
		var char_rot = character.get_rotation()
		char_rot.y = angle
		character.set_rotation(char_rot)
	

	var speed = hv.length() / SPEED
	speed = map(speed,0,1,-1,1)
	#get_node("AnimationTreePlayer").blend2_node_set_amount("Idle_Walk",speed)
	print("speed id:" + str(speed))
	get_node("AnimationTreePlayer").blend3_node_set_amount("Idle_Walk",speed)
	

func  map(value, istart, istop,  ostart,  ostop): 
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))
  


