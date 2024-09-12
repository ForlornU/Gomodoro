extends Node

enum State {FOCUS, BREAK, PAUSED}

#Sounds
const BACK_TO_WORK = preload("res://Assets/Audio/BackToWork.wav")
const TAKE_A_BREAK = preload("res://Assets/Audio/TakeABreak.wav")
const SOFT_STATECHANGE = preload("res://Assets/Audio/StateChangeSoft.wav")
const POP = preload("res://Assets/Audio/Pop.ogg")
const SHORT_ALARM = preload("res://Assets/Audio/ShortAlarm.wav")

#Profiles
var green_theme = ColorProfile.new(Color(0x516e56ff), Color(0xff7f50ff), Color(0x6a5acdff), Color(0xffd700ff))
var dark_theme = ColorProfile.new(Color.DARK_SLATE_GRAY, Color(0xff7f7fff), Color(0x87ceebff), Color(0xffd700ff))
var color_blind_dark_theme = ColorProfile.new(Color(0x2f4f4fff), Color(0xd55e00ff), Color(0x0072b2ff), Color(0xcc79a7ff))
var pomodoro_red_theme = ColorProfile.new(Color(0xff6347ff), Color(0x32cd32ff), Color(0x00bfff), Color(0xffd700ff))

var soft_audio_profile = AudioProfile.new(SOFT_STATECHANGE, SOFT_STATECHANGE, POP)
var harsh_audio_profile = AudioProfile.new(BACK_TO_WORK, TAKE_A_BREAK, POP)
var alarm_audio_profile = AudioProfile.new(SHORT_ALARM, SHORT_ALARM, POP)

var focus_duration = 1800 #Default 30min
var short_pause_duration = 300 # 5min
var cycles = 4 #How many work/break cycles before complete
