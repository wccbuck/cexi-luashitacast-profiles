local bluMag = T{};

bluMag.Phys = T{
    'Foot Kick', 'Sprout Smack', 'Wild Oats', 'Power Attack', 'Queasyshroom', 'Battle Dance', 'Feather Storm',
    'Helldive', 'Bludgeon', 'Claw Cyclone', 'Screwdriver', 'Grand Slam', 'Smite of Rage', 'Pinecone Bomb',
    'Jet Stream', 'Uppercut', 'Terror Touch', 'Mandibular Bite', 'Sickle Slash', 'Dimensional Death',
    'Spiral Spin', 'Death Scissors', 'Seedspray', 'Body Slam', 'Hydro Shot', 'Frenetic Rip', 'Spinal Cleave',
    'Hysteric Barrage', 'Asuran Claws', 'Disseverment', 'Ram Charge', 'Vertical Cleave',
    'Final Sting', 'Goblin Rush', 'Vanity Dive', 'Whirl of Rage', 'Benthic Typhoon', 'Quad. Continuum',
    'Empty Thrash', 'Delta Thrust', 'Heavy Strike', 'Quadrastrike', 'Tourbillion', 'Amorphic Spikes',
    'Barbed Crescent', 'Bilgestorm', 'Bloodrake', 'Glutinous Dart', 'Paralyzing Triad', 'Thrashing Assault',
    'Sinker Drill', 'Sweeping Gouge', 'Saurian Slide', 'Sub-zero Smash', 'Glutinous Dart'
}; -- excludes cannonball and stun spells
bluMag.PhysDex = T{
    'Asuran Claws', 'Smite of Rage', 'Frenetic Rip', 'Disseverment', 'Claw Cyclone', 'Hysteric Barrage',
    'Seedspray', 'Sickle Slash', 'Barbed Crescent', 'Foot Kick', 'Terror Touch'
};
bluMag.PhysAgi = T{
    'Pinecone Bomb', 'Wild Oats', 'Helldive', 'Jet Stream', 'Hydro Shot', 'Feather Storm', 'Spiral Spin'
};
bluMag.PhysVit = T{
    'Power Attack', 'Sprout Smack', 'Grand Slam', 'Quad. Continuum', 'Body Slam', 'Sub-zero Smash', 'Glutinous Dart'
};
bluMag.IntNuke = T{
    -- high WSC spells (marked by !!) might justify making a unique set just for them
    'Sandspin', 'Blastbomb', 'Bomb Toss', 'Corrosive Ooze', 'Cursed Sphere', 'Ice Break', 'Death Ray',
    'Blitzstrahl', 'Maelstrom', 'Spectral Floe',
    'Firespit', -- mnd 20%
    'Acrid Stream', -- mnd 30%
    'Regurgitation', -- mnd 30%
    'Anvil Lightning', -- dex 80% (!!)
    'Blinding Fulgor', -- str 30%, dex 30%, agi 30%
    'Silent Storm', -- agi 80% (!!)
    'Entomb', -- vit 80% (!!)
    'Searing Tempest', -- str 80% (!!)
    'Scouring Spate', -- mnd 80% (!!)
    'Tenebral Crush', -- mnd 30%, vit 30%
};
bluMag.MndNuke = T{
    'Mind Blast', 'Magic Hammer'
};
bluMag.ChrNuke = T{
    'Eyes on Me', 'Mysterious Light'
};
bluMag.Debuff = T{
    'Filamented Hold', 'Cimicine Discharge', 'Demoralizing Roar', 'Venom Shell', 'Light of Penance',
    'Sandspray', 'Auroral Drape', 'Frightful Roar', 'Enervation', 'Infrasonics', 'Lowing', 'CMain Wave',
    'Awful Eye', 'Voracious Trunk', 'Sheep Song', 'Soporific', 'Yawn', 'Dream Flower', 'Chaotic Eye',
    'Sound Blast', 'Blank Gaze', 'Stinking Gas', 'Geist Wall', 'Feather Tickle', 'Reaving Wind', 'Mortal Ray',
    'Absolute Terror', 'Blistering Roar', 'Cruel Joke', 'Jettatura', 'Cold Wave', 'Temporal Shift',
    'Actinic Burst'
};
bluMag.Stun = T{'Head Butt', 'Frypan', 'Tail Slap', 'Sudden Lunge'};
bluMag.Buff = T{
    'Cocoon', 'Refueling', 'Feather Barrier', 'Memento Mori', 'Zephyr Mantle', 'Warm-Up', 'Amplification',
    'Triumphant Roar', 'Saline Coat', 'Reactor Cool', 'Plasma Charge', 'Regeneration', 'Animating Wail',
    'Battery Charge', 'Winds of Promy.', 'Barrier Tusk', 'Orcish Counterstance', 'Pyric Bulwark',
    'Nat. Meditation', 'Restoral', 'Erratic Flutter', 'Carcharian Verve', 'Harden Shell', 'Mighty Guard'
};
bluMag.Drain = T{
    'Osmosis', 'Blood Drain', 'Digest', 'Blood Saber', 'MP Drainkiss'
};
bluMag.Cure = T{
    'Pollen', 'Healing Breeze', 'Wild Carrot', 'Magic Fruit', 'Exuviation', 'Plenilune Embrace'
};
bluMag.Breath = T{
    'Poison Breath', 'Magnetite Cloud', 'Hecatomb Wave', 'Radiant Breath', 'Flying Hip Press', 'Bad Breath',
    'Frost Breath', 'Heat Breath'
};

return bluMag;
