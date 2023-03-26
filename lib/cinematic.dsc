#
# Cinematic - a lib to do cool camera pan effects.
#

# Interpolates a position from a location to another.
# This task can (and usually should) be waited for.
cinematic_show:
	debug: false
    type: task
    definitions: player|from|to|target|speed
    script:
    - define original_gamemode <[player].gamemode>
    - define original_location <[player].location>
    - define original_fly_speed <[player].fly_speed>
    #
    - adjust <[player]> gamemode:spectator
    - adjust <[player]> fly_speed:0
    - define time <util.time_now>
    - look <[player]> <[target]> duration:999999s offthread_repeat:64
    - ~push <[player]> origin:<[from]> destination:<[to]> speed:<[speed]> precision:0.05 no_damage ignore_collision
    - look <[player]> cancel
    #
    - adjust <[player]> gamemode:<[original_gamemode]>
    - teleport <[player]> <[original_location]>
    - adjust <[player]> fly_speed:<[original_fly_speed]>
