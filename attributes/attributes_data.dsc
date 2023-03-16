attributes_config:
    debug: false
    type: data
    #
    max-level: 10
    # define required XP for each level
    # magic numbers using (xlnx)/10 then rounding and multiplying result by 10
    # result should be slightly more difficult than a simple linear progression
    required-xp:
        1: 450
        2: 1000
        3: 1700
        4: 2450
        5: 3100
        6: 3850
        7: 4600
        8: 5350
        9: 6150
        #10: last level
    #
    # attribute scaling
    scale-per-level:
        # 1 point == 1 extra heart of damage
        atk: 1
        # 1 point == 1 extra half armor
        def: 2
        # 1 point == 1 extra movement speed, player default speed == 0.1
        agi: 0.01
        # 1 point == 1 extra half heart of HP, 1 extra delay of stamina
        end: 2
        # 1 point == 1 extra heart of damage on projectiles
        dex: 1.75
        # 1 point == 1 extra heart of damage on magic
        int: 1
        # 1 point == 1 extra "half armor" worth of magic protection
        mnd: 1
