#
# Utility for creating temporary worlds.
# Inspired by DungeonsXL along other ideas.
#

world_container_make:
    debug: false
    type: task
    definitions: id|template
    script:
    # no duplicates
    - if <server.flag[world_container_all].if_null[<list[]>].contains[<[id]>]>:
        - debug ERROR "Duplicate world container <[id]>."
        - stop
    # valid template
    - if <server.worlds.parse[name].contains[template]>:
        - debug ERROR "Invalid template world <[template]>."
        - stop
    # generate template
    - define template_world <world[<[template]>]>
    - ~createworld <[id]> generator:denizen:void copy_from:<[template]> generate_structures:false save:generated_data
    - flag server world_container_all:<server.flag[world_container_all].if_null[<list[]>].include[<[id]>]>
    - flag server world_container_loaded:<server.flag[world_container_loaded].if_null[<list[]>].include[<[id]>]>
    - determine <world[<[id]>]>

world_container_destroy:
    debug: false
    type: task
    definitions: id|template
    script:
    # exists?
    - if !<server.flag[world_container_all].if_null[<list[]>].contains[<[id]>]>:
        - debug ERROR "World to destroy <[id]> not found."
        - stop
    # valid template
    - if <server.worlds.parse[name].contains[template]>:
        - debug ERROR "Invalid template world <[template]>."
        - stop
    # has players?
    - define template_world <world[<[template]>]>
    - define world <world[<[id]>]>
    - foreach <[world].players> as:player:
        - teleport <[player]> <[player].location.with_world[<[template_world]>]>
    # destroy all data
    - adjust <[world]> destroy
    - flag server world_container_all:<server.flag[world_container_all].if_null[<list[]>].exclude[<[id]>]>
    - flag server world_container_loaded:<server.flag[world_container_loaded].if_null[<list[]>].exclude[<[id]>]>

world_container_load:
    debug: false
    type: task
    definitions: id
    script:
    # exists?
    - if !<server.flag[world_container_all].if_null[<list[]>].contains[<[id]>]>:
        - debug ERROR "World to load <[id]> not found."
        - stop
    # loaded already?
    - if <server.flag[world_container_loaded].if_null[<list[]>].contains[<[id]>]>:
        - stop
    # load
    - ~createworld <[id]>
    - flag server world_container_loaded:<server.flag[world_container_loaded].if_null[<list[]>].include[<[id]>]>
    - determine <world[<[id]>]>

world_container_unload:
    debug: false
    type: task
    definitions: id|template
    script:
    # is loaded?
    - if !<server.flag[world_container_loaded].if_null[<list[]>].contains[<[id]>]>:
        - debug ERROR "World to unload <[id]> not found."
        - stop
    # valid template
    - if <server.worlds.parse[name].contains[template]>:
        - debug ERROR "Invalid template world <[template]>."
        - stop
    # has players?
    - define template_world <world[<[template]>]>
    - define world <world[<[id]>]>
    - foreach <[world].players> as:player:
        - teleport <[player]> <[player].location.with_world[<[template_world]>]>
    # unload
    - adjust <[world]> unload
    - flag server world_container_loaded:<server.flag[world_container_loaded].if_null[<list[]>].exclude[<[id]>]>
