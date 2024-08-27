extends Node

enum State {WORK, BREAK, PAUSED}

var work_time = 1800 #Default 30min
var short_pause_time = 300 # 5min
var cycles = 4 #How many work/break cycles before complete
