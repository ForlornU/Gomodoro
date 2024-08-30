extends Node

enum State {WORK, BREAK, PAUSED}

#Sounds
const BACK_TO_WORK = preload("res://Assets/Audio/BackToWork.wav")
const TAKE_A_BREAK = preload("res://Assets/Audio/TakeABreak.wav")
const SOFT_STATECHANGE = preload("res://Assets/Audio/StateChangeSoft.wav")
const POP = preload("res://Assets/Audio/Pop.ogg")

#Profiles
var green_theme = ColorProfile.new(Color(0x516e56FF), Color(0xFF7F50FF), Color(0x6A5ACDFF), Color(0xFFD700FF))
var dark_theme = ColorProfile.new(Color.DARK_SLATE_GRAY, Color(0xFF7F7FFF), Color(0x87CEEBFF), Color(0xFFD700FF))
var color_blind_dark_theme = ColorProfile.new(Color(0x2F4F4FFF), Color(0xD55E00FF), Color(0x0072B2FF), Color(0xCC79A7FF))

var soft_audio_profile = AudioProfile.new(SOFT_STATECHANGE, SOFT_STATECHANGE, POP)
var harsh_audio_profile = AudioProfile.new(BACK_TO_WORK, TAKE_A_BREAK, POP)

var work_duration = 1800 #Default 30min
var short_pause_duration = 300 # 5min
var cycles = 4 #How many work/break cycles before complete
