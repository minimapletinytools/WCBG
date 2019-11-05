This design document is another example of a game that fits into the economic games paradigm proposed here.

# Potato Survival
Potato Survival economically driven survival game.

## Economy
Single base token called LIFE, fluctuating supply. Needed to pay for transaction fees and various actions in game. Can be earned by playing the game.

## Animals
Each account can control up to one animal. Animals can be purchased from the using LIFE from the marketplace. Animals themselves also hold LIFE that they game obtain from interacting with the world.


## Gameplay
Gameplay is comparable to the mobile battle royale game called "Black Survival". All actions are executed on chain.

### Map
The game takes place on a cell based world map which animals can traverse and interact. At each cell, an animal can:
- Search - scour the area for entities to engage with. Search can be tuned to find specific entities.
- Travel - travel to an adjacent cell
- Rest - rest and recover HP. Rest can consume items or cost LIFE.

### Combat
If an animal searches an area they may encounter a wild animal or another player controlled animal and enter combat. Combat is automatic and animals will damage each other’s HP based on their stats. If an animal dies, the other animal earns experience and loots the remains of the defeated animal.

### Breeding
If two compatible animals meet in the wild, they may breed to produce offspring which is sold on the animal marketplace. LIFE-link and child sales are split 50/50 between the two parents. There are no gender requirements. Each animal can only breed once every <> blocks and breeding consumes a huge amount of energy. The animal’s starting stats are based on its parents.

### Death
Upon death, a portion of an animal's LIFE is sent back to the player's account. The remainder is either dropped or burnt.

## Marketplace
Parents choose the price of their child when it goes on the marketplace. Sales are split evenly between parents. A child’s price decays over time if there are no purchases. When a player purchases an animal, they also give the animal some LIFE which can be used as a resource in game.

## Treasure
There are 10 magical treasures scattered throughout the world. Once found, these treasures become privately owned public assets taxed under the harberger tax system. An account receive different buffs on their animals depending on what treasures they own. Treasure holders also earn VOICE credits over time for each treasure they hold.

## Governance

Certain parameters in the world are set through decentralized governance through quadratic voting using VOICE credits. Players can put up proposals to change tunable parameters in the world and alter gameplay. Example of tunable parameters:

- Marketplace taxation rate
- Universal Basic Income (paid to all living animals)
- Child limits
- LIFE redistribution policy after death

## FANCY
Future features to add

- non consensual breeding (animals fight first, to determine who is mother and sole LIFE-link parent and earns 100% of child sale)
- player run shops
- building permanent structures in game
- crafting system

-------------------

# IMPLEMENTATION NOTES

## Animals Types
- Bird - bonus movement and search
- Snake - bonus resting
- Cat - bonus stealth and attack

10% matchup modifiers:Bird > Snake > Cat > Bird

## Combat
<TODO>

### Stats
- HP
- STRENGTH - determines a character’s attack power
- DEXTERITY - determines a character’s attack speed
- WISDOM - determines a characters luck and perception
- STAMINA - determines a character’s hit points
- LIFE-link - a portion of a child’s earnings will come back to the parent based on the parents LIFE-link stat.

## Breeding and Genetics

Animals may only breed with their own type.

The offspring is built from genetics of parents.

<TODO>

## Items
- LIFE
- equipment
  - 1x defensive item
  - 1x offensive item
  - 1x charm

<FANCY: crafting, basic system can be something like child of light gems>

## Search

### Preference
- PVP
- PVE
- Player (name)
- Treasure
- Food

### Action
- Attack if possible
- Breed if possible
- Avoid if possible

<FANCY: timed dialog to choose option based on what was found>

### Defense
Upon being attacked
- Run away - prefer to avoid always
- Defend - prefer to fight if opponent attacks
- Counter attack - prefer to attack if opponent avoids

### Upon being mated
- Mate
- Avoid
- Counter attack

<FANCY: timed dialog to choose option based on what came up>

## Combat
Combat resolves automatically, both sides attack once. Both sides earn experience if neither side loses.

A attacks B
<TODO>

If one side loses, some of their items are dropped and some go to the winning animal. Half of life the losing animal carries the life is returned to the owner and the other half goes to the winner.

## Rest
<TODO>

## Map
<TODO>

Each cell the following stats:
- stealth modifier
- difficulty
- ecology
- <TODO more>

5x designated starting areas with high stealth modifiers. New animals are randomly assigned to one of these areas.

Each cell can hold items which decay over time (each dropped item is destroyed after <> blocks)

Each cell has a chance to generate PVE enemies based on ecology. Ecology increases over time and decreases as enemies are killed. Generated enemies threat is based on cell difficulty. Enemies have a chance to drop items and LIFE.


# Analysis
We resist temptation to do too much analysis here and we hope interesting emergent behavior will be outside anything we can predict. We will make just a few remarks:

- Potato survival is an competitive ecosystem and it is tempting to think of it from a zero-sum perspective. However, there may be some metric for economy of the entire world which may grow and shrink. In particular, the total amount of LIFE in circulation will change over time.
- QV for voting on in game parameters (such as LIFE redistribution policy on death) gives players control over rate of growth of the economy. With more LIFE is circulation, more players can be supported at once. However, with inflation, there is an expected decrease in token value.
