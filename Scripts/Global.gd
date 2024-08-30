extends Node

enum State {WORK, BREAK, PAUSED}

const BACK_TO_WORK = preload("res://Assets/Audio/BackToWork.wav")
const TAKE_A_BREAK = preload("res://Assets/Audio/TakeABreak.wav")
const SOFT_STATECHANGE = preload("res://Assets/Audio/StateChangeSoft.wav")

var work_duration = 1800 #Default 30min
var short_pause_duration = 300 # 5min
var cycles = 4 #How many work/break cycles before complete
