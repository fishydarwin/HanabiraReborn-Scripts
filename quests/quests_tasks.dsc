#
# A system focusing on questing.
# It automatically tracks quests based on a predefined quest structure.
#

# shows a little notification
quests_notify:
    debug: false
    type: task
    definitions: player|notification
    script:
    - toast targets:<[player]> <[notification]> frame:goal icon:writable_book
    - playsound <[player].location> <[player]> sound:block_note_block_pling
    - narrate targets:<[player]> format:quests_formats_main "Quest Progress:<&nl><&f><[notification]>"

# assigns a new quest to a player
quests_assign:
    debug: false
    type: task
    definitions: player|quest
    script:
    - define id <[quest].name>
    - define steps <[quest].data_key[steps]>
    - flag <[player]> quests_active:<map[].with[id].as[<[id]>].with[steps].as[<[steps]>]>
    - run <[quest].data_key[start_script]> def.player:<[player]>
    - run quests_notify def.player:<[player]> def.notification:<[steps].get[<[steps].keys.get[1]>]>
    # prepare cleanup
    - flag server quests_clean:<server.flag[quests_clean].if_null[<map[]>].with[<[player]>].as[<[id]>]>

# pops the current step from the player's step stack,
# effectively moving to the next step in the quest
# it also notifies the user of this.
quests_next:
    debug: false
    type: task
    definitions: player
    script:
    - if !<[player].has_flag[quests_active]>:
        - debug ERROR "Invalid quest next step call for <[player].name> - no active quest."
        - stop
    - define data <[player].flag[quests_active]>
    - define steps <[data].get[steps]>
    - define steps <[steps].exclude[<[steps].keys.get[1]>]>
    # check if was last step
    - if !<[steps].is_empty>:
        # not last step, continue quest
        - flag <[player]> quests_active:<[data].with[steps].as[<[steps]>]>
        - run quests_notify def.player:<[player]> def.notification:<[steps].get[<[steps].keys.get[1]>]>
    - else:
        # last step, finish quest
        - define quest <script[<[data].get[id]>]>
        - flag <[player]> quests_complete:<[player].flag[quests_complete].if_null[<list[]>].include[<[data].get[id]>].deduplicate>
        - flag <[player]> quests_active:!
        - run <[quest].data_key[exit_script]> def.player:<[player]>
        - run quests_notify def.player:<[player]> "def.notification:Completed <&6><[quest].data_key[name]>"
        # remove cleanup
        - flag server quests_clean:<server.flag[quests_clean].if_null[<map[]>].exclude[<[player]>]>

# returns the current active quest
quests_active_quest:
    debug: false
    type: procedure
    definitions: player
    script:
    - if !<[player].has_flag[quests_active]>:
        - determine null
    - determine <[player].flag[quests_active].get[id]>

# returns the current active quest step.
quests_active_step:
    debug: false
    type: procedure
    definitions: player
    script:
    - if !<[player].has_flag[quests_active]>:
        - determine null
    - define steps <[player].flag[quests_active].get[steps]>
    - determine <[steps].keys.get[1]>
