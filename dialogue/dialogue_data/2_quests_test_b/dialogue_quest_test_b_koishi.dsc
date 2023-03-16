# Koishi's Dialogue

dialogue_quests_test_b_koishi_assign:
    debug: false
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - dialogue_quests_test_b_koishi

dialogue_quests_test_b_koishi:
    debug: false
    type: interact
    steps:
        1:
            click trigger:
                script:
                - engage
                - ~run dialogue_narrate def.format:dialogue_formats_context "def.text:Koishi would stare towards the new face with great happiness."
                #
                - ~run dialogue_narrate def.format:dialogue_formats_npc "def.text:Hi! Hi! There's some trouble in Seinaru Mori..."
                - ~run dialogue_narrate def.format:dialogue_formats_npc "def.text:Ghouls! Ghouls! They are all over the place!"
                #
                - ~run dialogue_narrate def.format:dialogue_formats_npc "def.text:Please! Please! Could you please go kick their butts?"
                #
                - ~run dialogue_narrate def.format:dialogue_formats_context "def.text:The girl's tone would seem all over the place. Despite this, Seinaru Mori seems in trouble."
                # play ost
                - run quests_music_play def.player:<player> "def.title:Soul Sand Valley" def.sound:music_nether_soul_sand_valley def.speed:0.75
                # next step in quest
                - compass <location[-51,0,-79]>
                - run quests_next def.player:<player>
