#
# Clean up quests here
#

quests_world:
    debug: false
    type: world
    events:
        ## clean up on player quit
        on player quits:
        - if <player.has_flag[quests_active]>:
            - define quest <script[<player.flag[quests_active].get[id]>]>
            - define cleanup <[quest].data_key[clean_script]>
            - run <[cleanup]> def.player:<player>
            - flag server quests_clean:<server.flag[quests_clean].if_null[<map[]>].exclude[<[player]>]>
        ## clean up on server restart if any left
        after server start:
        - if !<server.flag[quests_clean].if_null[<map[]>].is_empty>:
            - foreach <server.flag[quests_clean]> key:player as:quest_id:
                - define quest <script[<[quest_id]>]>
                - define cleanup <[quest].data_key[clean_script]>
                - run <[cleanup]> def.player:<[player]>
            - flag server quests_clean:!
