extends Label

const SCREEN_SIZE := Vector2(80, 36)
const PLAY_AREA := Vector2(48, 34)

enum State {NEW, PLAY, DEAD}
var cur_state = State.NEW

# SCREEN[y][x]
const SCREEN := [
	#0         10        20        30        40        50        60        70        80
	#012345678901234567890123456789012345678901234567890123456789012345678901234567890
	'X##############################################################################X\n', #0
	'#                                                #                             #\n', #1
	'#                                                #                             #\n', #2
	'#                                                #  HI SCORE                   #\n', #3
	'#                                                #                        !    #\n', #4
	'#                                                #                             #\n', #5
	'#                                                #                             #\n', #6
	'#                                                #  SCORE                      #\n', #7
	'#                                                #                        !    #\n', #8
	'#                                                #                             #\n', #9
	'#                                                #                             #\n', #10
	'#                                                #                             #\n', #11
	'#                                                #                             #\n', #12
	'#                                                #                             #\n', #13
	'#                                                #                             #\n', #14
	'#                                                #                             #\n', #15
	'#                                                #                             #\n', #16
	'#                                                # (c)  AniMerrill Productions #\n', #17
	'#                                                #                             #\n', #18
	'#                                                #             2019            #\n', #19
	'#                                                #                             #\n', #20
	'#                                                ###############################\n', #21
	'#                                                #                             #\n', #22
	'#                                                #                             #\n', #23
	'#                                                #  CONTROLS                   #\n', #24
	'#                                                #                             #\n', #25
	'#                                                #                             #\n', #26
	'#                                                #       _                     #\n', #27
	'#                                                #                             #\n', #28
	'#                                                #     _|W|_    ___________    #\n', #29
	'#                                                #                             #\n', #30
	'#                                                #    |A|S|D|  | S P A C E |   #\n', #31
	'#                                                #     - - -    -----------    #\n', #32
	'#                                                #                             #\n', #33
	'#                                                #                             #\n', #34
	'X##############################################################################X\n', #35
]

var screen := []

export var INIT_SNAKE := [Vector2(5, 5), Vector2(4, 5), Vector2(3, 5)]
export var INIT_SPEED := 1

onready var speed := INIT_SPEED
var timer := 0.0

var snake := []
var snake_dir := 'right'

var food := Vector2(1, 1)

var highscore : int = 0
var score : int = 0

var up = false
var down = false
var left = false
var right = false

func _ready():
	"""
	# Useful to check and make sure the play area is correct
	for y in range(PLAY_AREA.y):
		for x in range(PLAY_AREA.x):
			screen[y + 1][x + 1] = '*'
	
	set_process(false)
	"""
	
	clear_screen()
	
	draw_score('high')
	draw_score()
	
	print_screen()
	
	pass

func _process(delta):
	match cur_state:
		State.NEW, State. DEAD:
			if Input.is_action_pressed("ui_accept"):
				cur_state = State.PLAY
				init_play()
		State.PLAY:
			get_input()
			
			timer += delta * speed
			
			if timer >= 1.0:
				timer = 0
				
				move_snake()
				
				clear_screen()
				draw_snake()
				draw_food()
				draw_score('high')
				draw_score()
				
				print_screen()

func get_input():
	up = Input.is_action_pressed('ui_up')
	down = Input.is_action_pressed('ui_down')
	left = Input.is_action_pressed('ui_left')
	right = Input.is_action_pressed('ui_right')

func draw_score(score_type = '', score_clear = false):
	var score_string = str(score)
	var y = 8
	
	if score_type == 'high':
		y = 4
		score_string = str(highscore)
	
	if score_clear:
		score_string = '                         '
	
	for i in score_string.length():
		screen[y][74 - score_string.length() + i + 1] = score_string[i]

#===PLAY FUNCTIONS============================================#
func init_play():
	clear_screen()
	
	spawn_snake()
	draw_snake()
	
	spawn_food()
	draw_food()
	
	draw_score('high')
	draw_score()
	
	print_screen()

func clear_screen():
	screen = []
	
	for y in (SCREEN.size()):
		screen.append(SCREEN[y])

func print_screen():
	text = ''
	
	for line in screen:
		text += line

func spawn_snake():
	snake = []
	
	for i in (INIT_SNAKE.size()):
		snake.append(INIT_SNAKE[i])
	
	snake_dir = 'right'
	speed = INIT_SPEED
	score = 0
	timer = 0.0

func draw_snake():
	for i in range(snake.size()):
		if i == 0:
			var snake_char = '<'
			
			match snake_dir:
				'up':
					snake_char = 'v'
				'down':
					snake_char = '^'
				'left':
					snake_char = '>'
			
			screen[snake[0].y + 1][snake[0].x + 1] = snake_char
		else:
			if snake[i] != Vector2(-1, -1):
				screen[snake[i].y + 1][snake[i].x + 1] = '+'

func spawn_food():
	randomize()
	food = Vector2(randi() % int(PLAY_AREA.x), randi() % int(PLAY_AREA.y))
	
	for body in snake:
		if food == body:
			spawn_food()

func draw_food():
	screen[food.y + 1][food.x + 1] = 'O'

func move_snake():
	match snake_dir:
		'up', 'down':
			if left:
				snake_dir = 'left'
			elif right:
				snake_dir = 'right'
		'left', 'right':
			if up:
				snake_dir = 'up'
			elif down:
				snake_dir = 'down'
	
	var prev_body = Vector2(-1, -1) # -1 is erroneous in an array
	
	for i in (snake.size()):
		if i == 0:
			prev_body = snake[0]
			
			match snake_dir:
				'up':
					snake[0].y -= 1
				'down':
					snake[0].y += 1
				'left':
					snake[0].x -= 1
				'right':
					snake[0].x += 1
			
			match screen[snake[0].y + 1][snake[0].x +1]:
				'#', '+':
					print('ded')
					cur_state = State.DEAD
				'O':
					score += 100
					
					if score > highscore:
						highscore = score
					
					if score % 500 == 0:
						speed += 1
						print('speed: ', speed)
					
					snake.append(Vector2(-1, -1))
					spawn_food()
		else:
			var new_body = prev_body
			prev_body = snake[i]
			
			snake[i] = new_body