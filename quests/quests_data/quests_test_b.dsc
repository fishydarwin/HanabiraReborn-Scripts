quests_quest_test_b:
    debug: false
    type: data
    # This is used in messages and GUI sometimes
    name: Seinaru Mori Testrun w NPCs
    description: Includes NPC Dialogue Testing, and more content. Tsukuyoma's yokai have gathered a series of undead creatures in Seinaru Mori. Can you stop them?
    # The start script is called right before the quest begins.
    start_script: quests_quest_test_b_start
    # The exit script is called as soon as the quest was finished.
    exit_script: quests_quest_test_b_exit
    # The clean script is called if a player quits mid-quest, server crashes, etc.
    clean_script: quests_quest_test_b_clean
    # The steps of the quest - these are ORDERED.
    steps:
        talk_to_koishi: Talk to Koishi. (check your compass)
        navigate_to_seinaru_mori: Navigate to Seinaru Mori. (check your compass)
        fight_the_zombies_1: Kill the ghouls!
        navigate_to_below_bridge: Move over to below the Bridge. (check your compass)
        fight_the_zombies_2: Kill the ghouls!
        # and so on...
    # The GUI material display & lore is generated automatically
    # The rest you must specify as a mechanism if desired.
    gui_material: spruce_sapling

# magic value dump
quests_quest_test_b_data:
    debug: false
    type: data
    koishi_skin: ewogICJ0aW1lc3RhbXAiIDogMTY3NDgwODYxNTkxNCwKICAicHJvZmlsZUlkIiA6ICI3NTA5NzZmODRmMDE0NWFhYTc0MzAwYWJhMzc5MTIzNCIsCiAgInByb2ZpbGVOYW1lIiA6ICIwY2hlYXRzIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2U3OWQyNTlmZjIxMzc2YjE0YzZjZWVmZDIxODRiNjc0OTI2MmU4ZmRhNWYxOTA5MDBkYWVmMzliMWQxZTEwZjAiLAogICAgICAibWV0YWRhdGEiIDogewogICAgICAgICJtb2RlbCIgOiAic2xpbSIKICAgICAgfQogICAgfQogIH0KfQ==;bueCDt4s0kBnvGU4uw286QNhSkwQFRRuxi+WGwSm+OTySnaFrrL2HU84Gpk7Gcz59TqWqPDA1oVlyCNvehdu+b5uB5yNab2e2subTU60y5USX8T8cb7UOEF2Q7Jm2XayIG6iLrJt3Nrb0m9efVSkZqzKEF5dc9MXYYb00gtRwBlynt/xSj4WwfhHqMCbvr4zv3glNKBx/jMXRP4m6k9rHHssm3RjlSvSuXcTe5vR+vgYJbCG9QJoC/UT3tvE4798dCB+cQoR07trCDCM2E9OOxWaJNl8SnNOpk21CNVxrzlkuccsjCtQtnMmKSfO8BXZCjMRhTt7oiFy+bf466ujoPRgHKrvqv6L58S12Q7eeaUzVRZgxJ9M6LICzcJ1njqIXX6FM1FPl4sQ/6RJkNfV+006IR64HTYpN4j1eW1HJfJATy5G8t6eVRSFLL9OWzyWQBH+IzE1PPAMLXOfp+1WjEX5FlU3m+YxKzdNwxwx39lpRt3ALtnVra8TRv14v/Ty0vmE0YbAxZ8K0t0tqtdyiNE4udKsSQkv2vFZSJqp9G2wZOXVSKqMmqDNaZ4i3sNoZHVyGORx+wy/dBLcK1h/O2y9lJC39B+EaB99KBYz8l7vp2+/cbB50FVBbKoObH+dQ6n6pV7iPLdbAB0W+oxLVA6TMZdLB3iBUyUohsd6v/E=;koishi

quests_quest_test_b_start:
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
    # create NPCs required for quest
    - create player "<&8>[<&c>NPC<&8>] <&7>Koishi" <location[-61,5,34,<[worldname]>]> save:koishi
    - define koishi <entry[koishi].created_npc>
    - lookclose <[koishi]> state:true range:10
    # magic value skin
    - adjust <[koishi]> skin_blob:<script[quests_quest_test_b_data].data_key[koishi_skin]>
    # dialogue
    - assignment set script:dialogue_quests_test_b_koishi_assign to:<[koishi]>
    ##
    # teleport player and tell player the story lol
    - define location <location[-96.5,1,22.5,0,-90,<[worldname]>]>
    - teleport <[player]> <[location]>
    # set compass starting point
    - compass player:<[player]> <location[-61,5,34]>
    #
    - wait 3s
    - narrate targets:<[player]> "<&nl><&4>NOTE <&7>This quest is <&l>experimental<&7>, and is meant to test the capabilities of our questing plugin.<&nl><&e>Any feedback is greatly appreciated!<&nl>"
    - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7>Seinaru Mori has been overrun with undead creatures. It seems Tsukuyomi's yokai are up to trouble again. The ghouls are threatening to destroy Hana. Will you be able to stop them before it's too late?"

quests_quest_test_b_exit:
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
    # de-allocate notes to prevent mem-leak
    - note remove as:quest_<[player].uuid>_playable
    - note remove as:quest_<[player].uuid>_seinaru_entrance
    - note remove as:quest_<[player].uuid>_below_bridge
    # clean world
    - wait 3s
    - define worldname quest_worlds/quest_<[player].uuid>
    - ~run world_container_destroy def.id:<[worldname]> def.template:main
    # story
    - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7>Thankfully, our protagonist was able to stop the ghoul invasion started by Tsukuyomi's yokai. It seems that Hana will live to fight for another day..."

quests_quest_test_b_clean:
    debug: false
    type: task
    definitions: player
    script:
    # take items
    - take player:<[player]> item:iron_sword
    - take player:<[player]> item:compass
    # de-allocate notes to prevent mem-leak
    - note remove as:quest_<[player].uuid>_playable
    - note remove as:quest_<[player].uuid>_seinaru_entrance
    - note remove as:quest_<[player].uuid>_below_bridge
    # clean world
    - define worldname quest_worlds/quest_<[player].uuid>
    - ~run world_container_destroy def.id:<[worldname]> def.template:main
    # quit quest
    - flag <[player]> quests_active:!

quests_quest_test_b_handler:
    debug: false
    type: world
    events:
        ## on player death, reset
        on player dies:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_test_b:
            - stop
        - determine cancelled passively
        - wait 1t
        - run quests_quest_test_b_clean def.player:<player>
        ## playable area
        on player exits cuboid:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_test_b:
            - stop
        # ignore when at first 2 steps
        - if <proc[quests_active_step].context[<player>]> == talk_to_koishi || <proc[quests_active_step].context[<player>]> == navigate_to_seinaru_mori:
            - stop
        - if <context.area.note_name.if_null[null]> == quest_<player.uuid>_playable:
            - wait 1t
            - teleport <player> <context.from>
            - run quests_quest_test_a_playable_area_message def.player:<player>
        ## quest stuff
        on player enters cuboid:
        - if <proc[quests_active_quest].context[<player>]> != quests_quest_test_b:
            - stop
        # seinaru mori entrance
        - if <proc[quests_active_step].context[<player>]> == navigate_to_seinaru_mori:
            - if <context.area.note_name.if_null[null]> == quest_<player.uuid>_seinaru_entrance:
                # summon some zombies at pseudo-random positions to fight
                - repeat 5:
                    - define position <location[-67,2,-102,<player.world.name>]>
                    - define position <[position].with_x[<[position].x.add[<util.random.int[-3].to[3]>]>]>
                    - define position <[position].with_z[<[position].z.add[<util.random.int[-3].to[3]>]>]>
                    - spawn zombie <[position]> target:<player> persistent save:zombie
                    - age <entry[zombie].spawned_entity> adult
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
                    - spawn zombie <[position]> target:<player> persistent save:zombie
                    - age <entry[zombie].spawned_entity> adult
                # next step
                - run quests_next def.player:<player>
        on zombie dies:
        - define player <player[<context.entity.world.name.replace[quest_worlds/quest_].with[]>].if_null[null]>
        - if <[player]> == null:
            - stop
        - if <proc[quests_active_quest].context[<[player]>]> != quests_quest_test_b:
            - stop
        - if <proc[quests_active_step].context[<[player]>]> == fight_the_zombies_1:
            - determine no_drops passively
            # if killed all, next step...
            - define left <[player].world.entities[zombie].size>
            - if <[left]> == 0:
                # next location compass
                - compass player:<[player]> <location[-46,0,-165]>
                - run quests_next def.player:<[player]>
            - else:
                - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7><[left]> ghouls left..."
        - else if <proc[quests_active_step].context[<[player]>]> == fight_the_zombies_2:
            - determine no_drops passively
            # if killed all, next step...
            - define left <[player].world.entities[zombie].size>
            - if <[left]> == 0:
                - run quests_next def.player:<[player]>
            - else:
                - narrate targets:<[player]> "<&8>[<&c>!<&8>] <&7><[left]> ghouls left..."
