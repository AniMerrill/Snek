extends Node

const SCREEN_SIZE := Vector2(80, 36)
const PLAY_AREA := Vector2(48, 34)

enum State {NEW, PLAY, DEAD, PAUSE, SPLASH}
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

const PAUSE_SCREEN := [
	'################################################', #0
	'#            **********************            #', #1
	'#        ******************************        #', #2
	'#    **************************************    #', #3
	'#  ********  P  A  U  S  E  D  !  !  ********  #', #4
	'#    **************************************    #', #5
	'#        ******************************        #', #6
	'#            **********************            #', #7
	'################################################'  #8
]

const GAME_OVER := [
	'################################################', #0
	'#                                              #', #1
	'#    - - - G  A  M  E    O  V  E  R ! - - -    #', #2
	'#                                              #', #3
	'#        N E W  H I G H  S C O R E ! ! !       #', #4
	'#                                              #', #5
	'#         PRESS SPACE TO PLAY AGAIN...         #', #6
	'#                                              #', #7
	'################################################'  #8
]

const TITLE_SCREEN := [
	'                                                ',
	'                                                ', #1
	'                                                ', #2
	'                                                ', #3
	'  ============================================  ', #4
	'  ============================================  ', #5
	'                                                ', #6
	'      -----                                     ', #7
	'     |  _  |                     -         --   ', #8
	'     |]| |o|                    | |       |  |  ', #9
	'     |]|  -~~<                  | |       |  |  ', #10
	'     |]|___    -----    -----   | |       |  |  ', #11
	'     |___  |  |     |  |     |  | |  -    |  |  ', #12
	'   ^     |]|  |     |  |  [] |  | | | |    --   ', #13
	'   ^     |]|  |  -  |  | ----   | |_|-          ', #14
	'  |[|    |]|  | | | |  | |_ _   |  _ -     --   ', #15
	'  |[|____|]|  | | | |  |     |  | | | |   |  |  ', #16
	'  |        |   -   -    -----    -   -     --   ', #17
	'   --------   ================================  ', #18
	'  ============================================  ', #19
	'  ============================================  ', #20
	'  ============================================  ', #21
	'                                                ', #22
	'                                                ', #23
	'                                                ', #24
	'                                                ', #25
	'                                                ', #26
	'                                                ', #27
	'                                                ', #28
	'                                                ', #29
	'                                                ', #30
	'              PRESS SPACE TO PLAY!              ', #31
	'                                                ', #32
	'                                                ', #33
]

const SPLASH_SCREEN := [
	'                                                ',
	'                A N I M E R R I L L             ', #1
	'                                                ', #2
	'               P R O D U C T I O N S            ', #3
	'                                                ', #4
	'                                                ', #5
	'                        #                       ', #6
	'                       #^#                      ', #7
	'                     #/  |#               ####  ', #8
	'                    #-    -#            ####    ', #9
	'                ####|      |######    ########  ', #10
	'              # --- |   |   -  ---# ######      ', #11
	'              #|    |   |    |    | ####        ', #12
	'              #|    --------------- ##          ', #13
	'             #------##########-    -#           ', #14
	'            #-    -####----####-    -#          ', #15
	'           #/    -###-  --  -###-    -#         ', #16
	'          #<    |###|  (##)  |###|--  >#        ', #17
	'           #- --|####-  --  -####|   /#         ', #18
	'            #-   -#####----#### -   -#          ', #19
	'             #-   -############-----#           ', #20
	'            ## ---------------    |#            ', #21
	'          #####|    |    |   |    |#            ', #22
	'        ###### #---  -   |   | --- #            ', #23
	'  ##########    ######|      |#####             ', #24
	'    ######            #-    -#                  ', #25
	'  ######               #|  /#                   ', #26
	'                        #v#                     ', #27
	'                         #                      ', #28
	'                                                ', #29
	'             http://www.animerrill.com          ', #30
	'                                                ', #31
	'                                                ', #32
	'                                                ', #33
]

export var INIT_SNAKE := [Vector2(5, 5), Vector2(4, 5), Vector2(3, 5)]
export var INIT_SPEED := 1

onready var get_wav : AudioStreamSample = preload('res://get.wav')
onready var splash_ogg : AudioStreamOGGVorbis = preload('res://animerrill_productions.ogg')
onready var game_over_ogg : AudioStreamOGGVorbis = preload('res://game_over.ogg')

onready var speed := INIT_SPEED

var label : Label = Label.new()
var audio : AudioStreamPlayer = AudioStreamPlayer.new()

var cur_screen := []

var snake := []
var snake_dir := 'right'

var food := Vector2(1, 1)

var timer := 0.0

var highscore : int = 5700
var prev_highscore : int = 0
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
			cur_screen[y + 1][x + 1] = '*'
	
	set_process(false)
	"""
	
	init_new()

func _process(delta):
	var space = Input.is_action_just_pressed("ui_accept")
	
	if Input.is_action_pressed('_'):
		foo()
		return
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	match cur_state:
		State.SPLASH:
			if not audio.playing:
				cur_state = State.NEW
			
			clear_cur_screen()
			
			draw_score('high')
			draw_score()
			
			draw_splash_screen()
			
			print_cur_screen()
		State.NEW, State.DEAD:
			if space:
				space = false
				cur_state = State.PLAY
				init_play()
			
			clear_cur_screen()
			
			draw_score('high')
			draw_score()
			
			if cur_state == State.NEW:
				draw_title_screen()
			if cur_state == State.DEAD:
				draw_game_over()
			
			print_cur_screen()
		State.PLAY:
			if space:
				space = false
				cur_state = State.PAUSE
			else:
				get_input()
				
				timer += delta * speed
				
				if timer >= 1.0:
					timer = 0
					
					move_snake()
					
					clear_cur_screen()
					draw_snake()
					draw_food()
					draw_score('high')
					draw_score()
					
					print_cur_screen()
		State.PAUSE:
			if space:
				space = false
				cur_state = State.PLAY
			
			clear_cur_screen()
			
			draw_snake()
			draw_food()
			draw_score('high')
			draw_score()
			
			draw_pause_screen()
			
			print_cur_screen()

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
		cur_screen[y][74 - score_string.length() + i + 1] = score_string[i]

func save_highscore():
	var f = File.new()
	f.open('user://highscore.save', File.WRITE)
	f.store_line(to_json({'highscore':highscore}))
	f.close()

func load_highscore():
	var f = File.new()
	
	if not f.file_exists('user://highscore.save'):
		return
	
	f.open('user://highscore.save', File.READ)
	highscore = parse_json(f.get_line())['highscore']
	f.close()

#===NEW FUNCTIONS=============================================#
func init_new():
	label.rect_size = Vector2(640, 360)
	
	var snek_font = DynamicFont.new()
	snek_font.font_data = preload('res://UbuntuMono-R.ttf')
	snek_font.extra_spacing_top = -4
	snek_font.extra_spacing_bottom = -6
	
	label.add_font_override('font', snek_font)
	
	add_child(label)
	
	add_child(audio)
	
	load_highscore()
	
	clear_cur_screen()
	
	draw_score('high')
	draw_score()
	
	print_cur_screen()
	
	splash_ogg.loop = false
	game_over_ogg.loop = false
	
	audio.stream = splash_ogg
	audio.play()
	
	cur_state = State.SPLASH

#===PLAY FUNCTIONS============================================#
func init_play():
	prev_highscore = highscore
	
	clear_cur_screen()
	
	spawn_snake()
	draw_snake()
	
	spawn_food()
	draw_food()
	
	draw_score('high')
	draw_score()
	
	print_cur_screen()

func clear_cur_screen():
	cur_screen = []
	
	for y in (SCREEN.size()):
		cur_screen.append(SCREEN[y])

func print_cur_screen():
	label.text = ''
	
	for line in cur_screen:
		label.text += line

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
			
			cur_screen[snake[0].y + 1][snake[0].x + 1] = snake_char
		else:
			if snake[i] != Vector2(-1, -1):
				cur_screen[snake[i].y + 1][snake[i].x + 1] = '+'

func spawn_food():
	randomize()
	food = Vector2(randi() % int(PLAY_AREA.x), randi() % int(PLAY_AREA.y))
	
	for body in snake:
		if food == body:
			spawn_food()

func draw_food():
	cur_screen[food.y + 1][food.x + 1] = 'O'

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
			
			match cur_screen[snake[0].y + 1][snake[0].x +1]:
				'#', '+':
					cur_state = State.DEAD
					
					if prev_highscore < score:
						highscore = score
						save_highscore()
					
					audio.stream = game_over_ogg
					audio.play()
				'O':
					score += 100
					
					if score > highscore:
						highscore = score
					
					if score % 500 == 0:
						speed += 1
					
					snake.append(Vector2(-1, -1))
					spawn_food()
					
					audio.stream = get_wav
					audio.play()
		else:
			var new_body = prev_body
			prev_body = snake[i]
			
			snake[i] = new_body

func draw_game_over():
	for y in GAME_OVER.size():
		for x in GAME_OVER[y].length():
			if y == 4 and prev_highscore >= score:
				cur_screen[y + 14][x + 1]  = GAME_OVER[y - 1][x]
			else:
				cur_screen[y + 14][x + 1] = GAME_OVER[y][x]

func draw_pause_screen():
	for y in PAUSE_SCREEN.size():
		for x in PAUSE_SCREEN[y].length():
			cur_screen[y + 14][x + 1] = PAUSE_SCREEN[y][x]

func draw_title_screen():
	for y in TITLE_SCREEN.size():
		for x in TITLE_SCREEN[y].length():
			cur_screen[y + 1][x + 1] = TITLE_SCREEN[y][x]

func draw_splash_screen():
	for y in SPLASH_SCREEN.size():
		for x in SPLASH_SCREEN[y].length():
			cur_screen[y + 1][x + 1] = SPLASH_SCREEN[y][x]

func foo():
	clear_cur_screen()
	
	draw_score('high')
	draw_score()
	
	for y in SECRET.size():
		for x in SECRET[y].length():
			cur_screen[y + 1][x + 1] = SECRET[y][x]
	
	print_cur_screen()


































const SECRET := [
	'                   ___________                  ',
	'                  (           )                 ', #1
	'                   -----------                  ', #2
	'                     --------                   ', #3
	'                    |  _____ |                  ', #4
	'                   |  |_______|                 ', #5
	'                  -| | o ||| o |                ', #6
	'                 | |    .    .                  ', #7
	'                  -|   | ____ |                 ', #8
	'                   |   |      |                 ', #9
	'          ---------     ------ ---              ', #10
	'         |                        |             ', #11
	'        |                          |            ', #12
	'       |         #############|     |           ', #13
	'      |     ________ ####### | |     |          ', #14
	'      |             | ###### |  |     |         ', #15
	'       _______      | ###### |   |     |        ', #16
	'      |      |      | ###### |    |    |        ', #17
	'      |       ------ ####### |    |    |        ', #18
	'      |          | #######  /     |    |        ', #19
	'      |          | ####    |      |     |       ', #20
	'      |          |          ______|     |       ', #21
	'      |          |      /         |     |       ', #22
	'      |          |     /          |     |       ', #23
	'      |   _____  |               | ------       ', #24
	'     |            |--------------               ', #25
	'      ------------                              ', #26
	'                                                ', #27
	'            * * * * * **** * * * * *            ', #29
	'          * *                      * *          ', #28
	'      * * * * R.I.P. H A R A M B E * * * *      ', #30
	'          * *                      * *          ', #33
	'            * * * * * **** * * * * *            ', #31
	'                                                ', #32
]