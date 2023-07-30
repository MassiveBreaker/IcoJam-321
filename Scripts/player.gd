extends CharacterBody2D


##Variables
#---------------------------
var acceleration : float = .2
var friction : float = .3
var speed : float = 20_000
var dashSpeed : float = 2000
var input : Vector2

var canDash : bool
var dashCoolDown : float = .5

var canStop : bool

var force : float
#---------------------------
@onready var dashTimer = $DashCooldown
@onready var dashSound : AudioStreamPlayer2D = $Sounds/DashSound
@onready var timeBar = $UI/TimeBar
#---------------------------

func _ready() -> void:
	Handler.timeSlow = false
	canDash = true
	canStop = true
	timeBar.value = 100

func _process(_delta: float) -> void:
	handleTimeBar()
	
func _physics_process(delta: float) -> void:
	move(delta)
	debug()
	forceCollision()
	move_and_slide()
	
func move(delta) -> void:
	velocity.x = lerp(velocity.x,getInput().x * speed * delta, acceleration)
	velocity.y = lerp(velocity.y,getInput().y * speed * delta, acceleration)
	dash()
	

func getInput() -> Vector2:
	input = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down")).normalized()
	#print(input)
	return input

func debug():
	$Debug/Velocity.text = str(velocity)
	$Debug/TimeSlowed.text = "Time Slowed: %s" % Handler.timeSlow
	$Debug/DashTime.text = "Dash Time: %0.1f" % dashTimer.time_left


func dash():
	if getInput() == Vector2.ZERO:
		return
	if Input.is_action_just_pressed("Dash") && canDash:
		velocity = getInput() * dashSpeed
		dashTimer.start(dashCoolDown)
		canDash = false
		dashSound.play()

func _on_dash_cooldown_timeout() -> void:
	canDash = true

func handleTimeBar():
	timeStop()
	barCanStop()
	timeBarColor()
	
func timeBarColor():
	if timeBar.value > 25:
		timeBar.get("theme_override_styles/fill").set_bg_color(Color8(0,56,183))
	elif timeBar.value < 25:
		timeBar.get("theme_override_styles/fill").set_bg_color(Color8(144,0,0))
	pass

func barCanStop() -> void:
	if timeBar.value == 0:
		canStop = false
		$"Sounds/During Slow".stop()
		$Sounds/TimeSpeed.play()
	elif timeBar.value >= 25:
		canStop = true

func timeStop():
	Handler.timeSlow = false
	if Input.is_action_pressed("Timestop") && canStop:
		timeBar.value -= .2
		Handler.timeSlow = true
	if Input.is_action_just_pressed("Timestop") && Handler.timeSlow:
		$Sounds/TimeSlow.play()
	if Handler.timeSlow:
		dashSpeed = 2500
		if !$"Sounds/During Slow".playing:
			$"Sounds/During Slow".play()
	elif !Handler.timeSlow:
		speed = 20_000
		dashSpeed = 2000
		timeBar.value += .1
	if Input.is_action_just_released("Timestop") && canStop:
		$"Sounds/During Slow".stop()
		$Sounds/TimeSpeed.play()
	pass
	
	
	
func forceCollision() -> void:
	force = (sqrt(pow(velocity.x,2) + pow(velocity.y,2))) * 5
	#print(force)
	if dashTimer.time_left > .35:
		force = 15000
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody2D:
			col.get_collider().apply_force(col.get_normal() * -force)
