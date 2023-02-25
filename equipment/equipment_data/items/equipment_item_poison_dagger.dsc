equipment_item_Poison_dagger:
    debug: false
    type: data
    #
    itemtype: dagger
    material: <item[wooden_sword[custom_model_data=1]]>
    allow-duplicates: true
    weight: 5
    #
    name: &a&oPoison Sword
    description: A Dagger used by common assasins coated in weak poison.
    #
    stats:
        dex: 3
    #
    abilities:
        hit: equipment_item_poison_dagger_hit

equipment_item_poison_dagger_hit:
    debug: false
    type: task
    definitions: player|target|damage
    description: Applies poison to the target
    script:
    - hurt <[damage].mul[<[player].flag[attributes].get[dex]>]> <[target]> source:<[player]>
    - ratelimit <player> 15s
    - Cast poison duration:10 amplifier:0 hide_particles