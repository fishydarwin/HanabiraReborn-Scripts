equipment_item_blue_sword:
    debug: false
    type: data
    #
    itemtype: sword
    material: <item[iron_sword[custom_model_data=1]]>
    allow-duplicates: true
    weight: 5
    #
    name: &a&oPoison Sword
    description: A sword forged from a special alloy of steel from primeval fire.
    #
    stats:
        dex: 4
    #
    abilities:
        hit: equipment_item_poison_sword_hit

equipment_item_poison_sword_hit:
    debug: false
    type: task
    definitions: player|target|damage
    description: Scales up damage with 20% of ATK stat.
    script:
    - hurt <[damage].mul[<[player].flag[attributes].get[dex]>].mul[0.2]> <[target]> source:<[player]>
    - Cast poison duration:20 amplifier:1 hide_particles