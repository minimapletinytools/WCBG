struct Working {
    uint16 landId;
    uint8 jobIndex;
}

struct Job {
   ItemType itemType;
}

struct LandPosition {
    uint8 X;
    uint8 Y;
}

struct LandStats {
    uint16 sun;
    uint16 water;
    uint16 humidity;
    uint16 topology;
    uint16 temp;
    uint16 fertility;
    uint16 oil;
    uint16 coal;
    uint16 mineral;
    uint16 beauty;
    uint16 diversity;
    uint16 air;
}

struct Land {
    string name;
    uint256 value;
    Job[] jobs;

    LandStats stats;

    uint64 lastUpdate;
    uint64 lastTaxUpdate;
}

// implicit land params (derived from ERC721 fields)
// LandPosition pos;
// LandStats startingStats;
// address owner;

struct Diet {
    // TODO
}

struct AnimalStats {
    uint16 str;
    uint16 intel;
    uint16 dex;
    uint16 charisma;

    // diet needs
    uint16 fiber;
    uint16 protein;
    uint16 carb;
    uint16 fat;
}

struct Animal {
    Address master;
    string name;
    uint256 value;
    Working job;

    AnimalStats stats;

    uint32 energy;
    uint32 happiness;
    uint32 voiceCredits;
    Diet diet;

    uint64 lastUpdate;
    uint64 lastTaxUpdate;
}

struct PublicPolicy {
    // tax is over tax/10000 per 1000 blocks
    uint16 landTax;
    uint16 animalTax;

    // masters should have at least taxReserve/100 * <taxation per 1000 blocks>
    uint16 taxReserve;

}

library Masters {
    // TODO use more efficient dense storage since # of times are finite
    mapping (address=>mapping (ItemType => uint)) items;
    mapping (address=>uint256) tokens;
    function addItem(address owner, ItemType itemType, uint quantity) {
        // TODO do overflow checks on item quantity
        items[owner][itemType] += quantity;
    }

    // TODO total harberger tax reserve liability (to ensure enough funds to pay all tax)
}

// TODO more items
enum ItemType { CORN, STUFF }

// contract vars
Masters masters;
animals mapping(uint256 => Animal);



// animal transactions
function SetPrice(uint256 animalId, uint256 price) external {
    animal = animals[animalId];

    if(price > animal.price) {
        // TODO check master's tax reserve liability
    }

    // must tax before setting price to ensure lazyness is correct
    taxAnimal(animal);

    animal.price = price;

    // TODO update master tax reserve liability
}

function UpdateAnimal(uint256 animalId) {
    animal = animals[animalId];

    // TODO finish

    // do we need this?
    taxAnimal(animal);

    // update hunger

    // update work

    // ?is it a problem if there are future updates in the same block#?
    // ?maybe 1 action/user limitation (also means you can keep track of oldest animal more easily)
    animal.lastUpdate = block.number;
}

function PurchaseAnimal(uint256 animalId, uint256 price) {
    animal = animals[animalId];

    // check for sufficient funds
    require(masters.tokens[msg.sender] > price);
    masters.tokens[msg.sender] -= price;

    // TODO check master's tax reserve liability



    // update animal so that previous owner gets earnings up until the purchase
    UpdateAnimal(animalId);

    // update ownership
    animal.master = msg.sender

    // TODO set the price (same as SetPrice, but remove tax liability check and taxAnimal)
}

// animal internal functions
function taxAnimal(Animal storage animal) {
    // TODO charge tax

    animal.lastTaxUpdate = block.number;
}


//function SetPrice(uint256 landId, uint256 price) {

// land transactions
function UpdateLand(Land storage land) {
    // TODO finish

    taxLand(land);

    // TODO force update jobs?

    // TODO update ecology (or does this happen when jobs get updated?)

    land.lastUpdate = block.number;
}

// land internal functions
//function taxLand(Land storage land) {


function work(Animal storage animal, Land land, Job job)
{
    output = typeProductivity(job) * jobCompat(animal, job) * landCompat(land, job);
    masters.addItem(animal.owner, job.ItemType, output)
}

// lookup/compatability functions
function jobProductivity(Job job) pure returns float {
    if(job.itemType == CORN) {
        return 1.0;
    } else if (job.itemType == STUFF) {
        return 0.8;
    }
}

// compatability functions
function jobCompat(Animal animal, Job job) pure returns float {
    // TODO
}

function landCompat(Land land, Job job) pure returns float {
    // TODO
}
