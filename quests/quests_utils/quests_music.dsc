#
# Lets you play OST with a cool toast and ensures no multiple OSTs happen at once.
# It also makes it easy to end the music at any point if need be, without extra safety checks.
#

quests_music_play:
    debug: false
    type: task
    definitions: player|title|sound|speed
    script:
    # clear music if any
    - run quests_music_end def.player:<[player]>
    # store music data
    - flag <[player]> quests_music:minecraft:<[sound]>
    # play music
    - playsound <[player].location> <[player]> sound:<[sound]> pitch:<[speed]> sound_category:records
    # OST notification
    - wait 2s
    - toast "<&6>♫ <&gradient[from=red;to=blue]><[title]><&nl><&7>(<[speed].mul[100].round_down_to_precision[0.01]>% speed)" targets:<[player]> icon:jukebox

quests_music_end:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].has_flag[quests_music]>:
        - adjust <[player]> stop_sound:<[player].flag[quests_music]>
        - flag <[player]> quests_music:!

# NB! no need to clear this flag on server close. even if it persists it's fine
# by default this gets overwritten anyways, and adjusting on a non-playing sound will not break.
