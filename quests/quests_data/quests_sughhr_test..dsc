quests_quest_test_sughrr:
    debug: false
    type: data
    # This is used in messages and GUI sometimes
    name: Example Quest test
    description: This quest is an example of what a quest should look like
    # The start script is called right before the quest begins.
    start_script: quests_quest_example_start
    # The exit script is called as soon as the quest was finished.
    exit_script: quests_quest_example_exit
    # The clean script is called if a player quits mid-quest, server crashes, etc.
    clean_script: quests_quest_example_clean
    # The steps of the quest - these are ORDERED.
    steps:
        some_step_1: The description of step 1.
        some_step_2: The description of step 2.
        # and so on...
    # The GUI material display & lore is generated automatically
    # The rest you must specify as a mechanism if desired.
    gui_material: stone

quests_quest_test_sughrr_start:
    debug: false
    type: task
    # this definition must only contain a player
    definitions: player
    script:
    # make world
    - define world_name quests/quest_<[player].uuid>
    - run world_container_make def.id:<[world_name]> def.template.hanabira
    #define regions
    - note <cuboid[<[world_name]>,-44,8,65,-52,2,48]> as:quests_<[player].uuid>_bridge
    - note <cuboid[<[world_name]>,-7,3,66,-17,8,46]> as:quests_<[player].uuid>_fishing_house
    - note <cuboid[<[world_name]>,-75,3,39,-91,20,19]> as:quests_<[player].uuid>_town_center
 # teleport player
    - teleport <[player]> <location[-40,3.84,<[world_name]>]>

quests_quest_test_sughrr_exit:
    debug: false
    type: task
    # this definition must only contain a player
    definitions: player
    script:
    - run quests_quest_test_sughrr_clean def.player:<[player]>

quests_quest_test_sughrr_clean:
    debug: false
    type: task
    definitions: player
    script:
    # we need the world name...
    - define world_name quests/quest_<[player].uuid>
    # first clear the cuboids before deleting the world!
    - note remove as:quests_<[player].uuid>_bridge
    - note remove as:quests_<[player].uuid>_fishing_house
    - note remove as:quests_<[player].uuid>_town_center
    # delete world - should always be the last step
    - run world_container_destroy def.id:<[world_name]> def.template:hanabira

quests_quest_test_sughrr_handler:
    debug: false
    type: world
    events:
        on player enters cuboid:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_sughrr_test:
            - stop
        - define area <context.area.note_name.if_null[null]>
        - if <[area]> == quest_<player.uuid>_bridge:
            - if <proc[quests_active_step].context[<player>]> != walk_to_bridge:
                - stop
            - run quests_next def.player:<player>
        - if <[area]> == quest_<player.uuid>_house:
            - if <proc[quests_active_step].context[<player>]> != walk_to_fishing_house:
                - stop
            - run quests_next def.player:<player>
        - if <[area]> == quest_<player.uuid>_house:
            - if <proc[quests_active_step].context[<player>]> != walk_to_town_center:
                - stop
            - run quests_next def.player:<player>