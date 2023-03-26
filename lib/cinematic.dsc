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
    - definemap crash_data:
        gamemode: <[original_gamemode]>
        location: <[original_location]>
        fly_speed: <[original_fly_speed]>
    # crash safety
    - flag <[player]> cinematic:<[crash_data]>
    #
    - adjust <[player]> gamemode:spectator
    - adjust <[player]> fly_speed:0
    - define time <util.time_now>
    - look <[player]> <[target]> duration:999999s offthread_repeat:64
    - ~push <[player]> origin:<[from]> destination:<[to]> speed:<[speed]> precision:0.05 no_damage ignore_collision
    - if !<[player].is_online>:
        - stop
    - look <[player]> cancel
    #
    - adjust <[player]> gamemode:<[original_gamemode]>
    - teleport <[player]> <[original_location]>
    - adjust <[player]> fly_speed:<[original_fly_speed]>
    #
    - flag <[player]> cinematic:!

# ensures the player/server can crash without consequences.
# prevents misuse
cinematic_world:
    debug: false
    type: world
    events:
        ## help fix crashes
        after player joins:
        - if <player.has_flag[cinematic]>:
            #
            - adjust <player> gamemode:<player.flag[cinematic].get[gamemode]>
            - teleport <player> <player.flag[cinematic].get[location]>
            - adjust <player> fly_speed:<player.flag[cinematic].get[fly_speed]>
            #
            - flag <player> cinematic:!
            #
            - wait 1t
            - look <player> cancel
        ## prevent misuse
        on player chats bukkit_priority:low:
        - if <player.has_flag[cinematic]>:
            - determine cancelled
        on command bukkit_priority:low:
        - if <context.source_type> == player:
            - if <player.has_op>:
                - stop
            - if <player.has_flag[cinematic]>:
                - determine cancelled
