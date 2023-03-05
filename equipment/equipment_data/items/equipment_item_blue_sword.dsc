equipment_item_blue_sword:
    debug: false
    type: data
    #
    itemtype: sword
    material: <item[iron_sword[custom_model_data=1]]>
    allow-duplicates: true
    weight: 5
    #
    name: &b&oBlue Sword
    description: A sword forged from a special alloy of steel from primeval fire.
    #
    stats:
        atk: 2
    #
    abilities:
        hit: equipment_item_blue_sword_hit

equipment_item_blue_sword_hit:
    debug: false
    type: task
    definitions: player|target|damage
    description: Scales up damage with 20% of ATK stat.
    script:
    - hurt <[damage].mul[<[player].flag[attributes].get[atk]>].mul[0.2]> <[target]> source:<[player]>
