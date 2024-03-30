address 0x1 {
    module Card {

        use std::signer;
        use std::string::utf8;
        use std::Random;

        struct Card {
            name: string,
            faction: string,
            level: u8,
            race: string,
            power: u32,
            profession: string,
            skills: vector<string>
        }

        public fun createCard(name: string, faction: string, race: string, profession: string, skills: vector<string>) acquires Card {
            let level: u8 = generateRandomLevel();
            let power: u32 = calculatePower(level); // Assuming there's a function to calculate power based on level
            return Card {
                name: name,
                faction: faction,
                level: level,
                race: race,
                power: power,
                profession: profession,
                skills: skills
            };
        }

        // Function to generate random level with weighted distribution
        public fun generateRandomLevel(): u8 {
            let weights: array<u8> = [1, 2, 3];
            let probabilities: array<u8> = [50, 30, 20]; // Adjust the probabilities as desired

            let totalWeight: u8 = 0;
            let cumulativeProbabilities: array<u8> = [];
            for (i, weight) in weights {
            totalWeight += weight;
            cumulativeProbabilities.push(totalWeight);
            }

            let randomValue: u8 = Random::u8_in_range(1, 101); // Generate a random value between 1 and 100

            let level: u8 = 1;
            for (i, probability) in probabilities {
            if (randomValue <= cumulativeProbabilities[i]) {
            level = weights[i];
            break;
            }
            }

            return level;
        }


    }
}