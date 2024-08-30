extends Node

enum State {WORK, BREAK, PAUSED}

#Sounds
const BACK_TO_WORK = preload("res://Assets/Audio/BackToWork.wav")
const TAKE_A_BREAK = preload("res://Assets/Audio/TakeABreak.wav")
const SOFT_STATECHANGE = preload("res://Assets/Audio/StateChangeSoft.wav")

#Themes
var green_theme = ColorTheme.new(Color(0x516e56FF), Color(0xFF7F50FF), Color(0x6A5ACDFF), Color(0xFFD700FF))
var dark_theme = ColorTheme.new(Color.DARK_SLATE_GRAY, Color.AQUA, Color.BLUE, Color.DARK_CYAN)

var work_duration = 1800 #Default 30min
var short_pause_duration = 300 # 5min
var cycles = 4 #How many work/break cycles before complete
