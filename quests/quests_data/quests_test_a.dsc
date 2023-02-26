quests_quest_test_a:
    debug: false
    type: data
    # This is used in messages and GUI sometimes
    name: Seinaru Mori Testrun
    description: Tsukuyoma's yokai have gathered a series of undead creatures in Seinaru Mori. Can you stop them?
    # The start script is called right before the quest begins.
    start_script: quests_quest_test_a_start
    # The exit script is called as soon as the quest was finished.
    exit_script: quests_quest_test_a_exit
    # The clean script is called if a player quits mid-quest, server crashes, etc.
    clean_script: quests_quest_test_a_clean
    # The steps of the quest - these are ORDERED.
    steps:
        navigate_to_seinaru_mori: Navigate to Seinaru Mori. (check your compass)
        fight_the_zombies_1: Kill the ghouls!
        navigate_to_below_bridge: Move over to below the Bridge. (check your compass)
        fight_the_zombies_2: Kill the ghouls!
        # and so on...
    # The GUI material display & lore is generated automatically
    # The rest you must specify as a mechanism if desired.
    gui_material: spruce_sapling

quests_quest_test_a_start:
    debug: false
    type: task
    # this definition must only contain a player
    definitions: player
    script:
    - define worldname quest_worlds/quest_<[player].uuid>
    # make world
    - ~run world_container_make def.id:<[worldname]> def.template:main save:world
    # set up world data
    - define world <entry[world].created_queue.determination.get[1]>
    - adjust <[world]> difficulty:normal
    - time 18000t <[world]>
    # note playable region
    - note <cuboid[<[worldname]>,-26,-10,-45,-91,38,-217]> as:quest_<[player].uuid>_playable
    # note seinaru mori starting location and below bridge starting location
    - note <cuboid[<[worldname]>,-47,0,-76,-57,6,-81]> as:quest_<[player].uuid>_seinaru_entrance
    - note <cuboid[<[worldname]>,-60,10,-176,-31,-3,-159]> as:quest_<[player].uuid>_below_bridge
    # give weapon and compass
    #TODO: test only
    - give iron_sword player:<[player]>
    - give compass player:<[player]>
    ##
    # teleport player and tell player the story lol
    - define location <location[-47,1,-56,3,170,<[worldname]>]>
    - teleport <[player]> <[location]>
    # set compass starting point
    - compass player:<[player]> <location[-51,0,-79]>
    #
    - wait 3s
    - narrate targets:<[player]> "<&nl><&4>NOTE <&7>This quest is <&l>experimental<&7>, and is meant to test the capabilities of our questing plugin.<&nl><&e>Any feedback is greatly appreciated!<&nl>"
    - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7>Seinaru Mori has been overrun with undead creatures. It seems Tsukuyomi's yokai are up to trouble again. The ghouls are threatening to destroy Hana. Will you be able to stop them before it's too late?"

quests_quest_test_a_exit:
    debug: false
    type: task
    # this definition must only contain a player
    definitions: player
    script:
    # award xp
    - run attributes_xp_give def.player:<[player]> def.amount:100
    # take items
    - take player:<[player]> item:iron_sword
    - take player:<[player]> item:compass
    # clean world
    - wait 3s
    - define worldname quest_worlds/quest_<[player].uuid>
    - ~run world_container_destroy def.id:<[worldname]> def.template:main
    # story
    - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7>Thankfully, our protagonist was able to stop the ghoul invasion started by Tsukuyomi's yokai. It seems that Hana will live to fight for another day..."

quests_quest_test_a_clean:
    debug: false
    type: task
    definitions: player
    script:
    # take itemsu
    - take player:<[player]> item:iron_sword
    - take player:<[player]> item:compass
    # clean world
    - define worldname quest_worlds/quest_<[player].uuid>
    - ~run world_container_destroy def.id:<[worldname]> def.template:main
    # quit quest
    - flag <[player]> quests_active:!

quests_quest_test_a_playable_area_message:
    debug: false
    type: task
    definitions: player
    script:
    - ratelimit <[player]> 2s
    - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7>I should probably follow my compass..."

quests_quest_test_a_handler:
    debug: false
    type: world
    events:
        ## playable area
        on player exits cuboid:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_test_a:
            - stop
        - if <context.area.note_name.if_null[null]> == quest_<player.uuid>_playable:
            - wait 1t
            - teleport <player> <context.from>
            - run quests_quest_test_a_playable_area_message def.player:<player>
        ## quest stuff
        on player enters cuboid:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_test_a:
            - stop
        # seinaru mori entrance
        - if <proc[quests_active_step].context[<player>]> == navigate_to_seinaru_mori:
            - if <context.area.note_name.if_null[null]> == quest_<player.uuid>_seinaru_entrance:
                # summon some zombies at pseudo-random positions to fight
                - repeat 5:
                    - define position <location[-67,2,-102,<player.world.name>]>
                    - define position <[position].with_x[<[position].x.add[<util.random.int[-3].to[3]>]>]>
                    - define position <[position].with_z[<[position].z.add[<util.random.int[-3].to[3]>]>]>
                    - spawn zombie <[position]> target:<player>
                # next step
                - run quests_next def.player:<player>
        # below bridge area
        - else if <proc[quests_active_step].context[<player>]> == navigate_to_below_bridge:
            - if <context.area.note_name.if_null[null]> == quest_<player.uuid>_below_bridge:
                # summon some zombies at pseudo-random positions to fight
                - repeat 5:
                    - define position <location[-42,0,-178,<player.world.name>]>
                    - define position <[position].with_x[<[position].x.add[<util.random.int[-3].to[3]>]>]>
                    - define position <[position].with_z[<[position].z.add[<util.random.int[-3].to[3]>]>]>
                    - spawn zombie <[position]> target:<player>
                # next step
                - run quests_next def.player:<player>
        after zombie killed by player:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_test_a:
            - stop
        - if <proc[quests_active_step].context[<player>]> == fight_the_zombies_1:
            - determine no_drops passively
            # if killed all, next step...
            - define left <player.world.entities[zombie].size>
            - if <[left]> == 0:
                # next location compass
                - compass <location[-46,0,-165]>
                - run quests_next def.player:<player>
            - else:
                - narrate "<&8>[<&c>!<&8>] <&7><[left]> ghouls left..."
        - else if <proc[quests_active_step].context[<player>]> == fight_the_zombies_2:
            - determine no_drops passively
            # if killed all, next step...
            - define left <player.world.entities[zombie].size>
            - if <[left]> == 0:
                - run quests_next def.player:<player>
            - else:
                - narrate "<&8>[<&c>!<&8>] <&7><[left]> ghouls left..."
