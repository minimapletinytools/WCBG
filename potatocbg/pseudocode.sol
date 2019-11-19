// constants
uint TAX_DENOM = 10000000;
uint32 ENERGY_PER_POTATO = 100;
uint32 ENERGY_PER_BLOCK_WORKED = 100;
uint32 ENERGY_PER_BLOCK_BASE = 1;
uint32 MAX_ENERGY = 0xFFFFFFFF;
uint32 VC_PER_BLOCK = 100;

struct Working {
    uint16 landId;
    uint8 jobIndex;
    uint64 lastWorkUpdate;
}

struct Job {
   ItemType itemType;
   uint wage;
   uint strReq;
   uint dexReq;
   uint intReq;
   uint chrReq;
}

struct Agriculture {
    uint sunIdeal;
    unit rainIdeal;
    uint topIdeal;
    uint tempIdeal;
}

struct LandPosition {
    uint8 X;
    uint8 Y;
}

struct LandStats {
    uint16 sun;
    uint16 rain;
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
    Address owner;
    string name;
    uint256 value;

    // fixed size array
    Job[] jobs;
    uint256[] workingAnimals;

    LandStats stats;

    uint64 lastUpdate;
    uint64 lastTaxUpdate;
}

// implicit land params (derived from ERC721 fields)
// LandPosition pos;
// LandStats startingStats;
// address owner;

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
    Diet diet;

    uint64 lastUpdate;
    uint64 lastTaxUpdate;
}

// TODO public policy proposal + voting to pass

struct PublicPolicy {
    // tax is tax/TAX_DENOM * <value> per block
    uint32 landTax;
    uint32 animalTax;

    // tax is tax/TAX_DENOM * emmissions
    uint carbonTax;

    // other parameters
    // severance?
    // uint severanceBlocks;
    // insurance for failure to pay salary or
    // finders fee per block
    // finders fee bonus per overdue block
    // bankrupcy finders fee?
    // bankrupcy thresheld? (amonut owed > threshold*asset value)

}

struct Master {
    // todo use more efficient dense storage since # of times are finite
    mapping (ItemType => uint) items;
    uint256 tokens; // potatoes
    uint256 publicDebt;
    uint256 voiceCredits;
}

library Masters {
    mapping (address=>master) masters;
    function addItem(address owner, ItemType itemType, uint quantity) {
        // todo do overflow checks on item quantity
        masters[owner].items[itemType] += quantity;
    }
    function balance(address owner) {
        return tokens[owner];
    }
    // returns new debt accrued
    function subBalance(address owner, uint256 value) returns uint256 {
        Master storage master = masters[owner];
        if(value > master.tokens) {
            uint256 newDebt = value - masters.tokens;
            masters.tokens = 0;
            master.debt += newDebt

            // TODO handle force bankrupcy
            // IDK if public debt exceeds total value of all assets owed, then player really goes bankrupt and relinquishes all assets to the government for auction.
            //if(master.debt > master.totalAssetValue*law.bankruptThreshold)

            // todo debt needs to be taken from public's reserve

            return newDebt;
        }
        master.tokens -= value;
        return 0;
    }
    function addBalance(address owner, uint256 value) {
        Master storage moster = masters[owner];
        // pay off debt first
        if (master.debt > 0 ){
            // TODO finish
            //masters[GOV_ADDRESS].addBalance(min(value,master.debt))
        }
        masters[owner].tokens += value;
    }
}


// TODO more items
enum ItemType { NIL_ITEM = 0, CORN, STUFF }

// contract vars
Masters masters;
animals mapping(uint256 => Animal);
lands mapping(uint256 => Land);

PublicPolicy law;

// public owned tokens are stored here
address GOV_ADDRESS = 0xBABB0;


// master functions
// this taxes the master at tax/TAX_DENOM*amount per block
function levyTax(address master, uint16 tax, uint256 amount, uint blocks) {
    // there is some round off error, prob not a big deal
    taxPerBlock = tax/TAX_DENOM * amount;
    taxAmount =  taxPerBlock * blocks;
    basicTax(master, taxAmount);
}

function basicTax(address master, uint amount) {
    masters.subBalance(master, amount);
    masters.addBalance(GOV_ADDRESS, amount);
}

function carbon(address master, int amount) {
    if(amount > 0){
        basicTax(master,amount);
    } else {
        // TODO consider carbon rebates
    }

    // TODO update global carbon levels
}

// animal transactions
function SetAnimalPrice(uint256 animalId, uint256 price) external {
    animal = animals[animalId];

    // must tax before setting price to ensure lazyness is correct
    taxAnimal(animal);

    setAnimalPrice(animal, price)
}


function PurchaseAnimal(uint256 animalId, uint256 price) {
    animal = animals[animalId];

    // check for sufficient funds
    require(masters.balance(msg.sender) > price);
    masters.subBalance(msg.sender, price);
    masters.addBalance(animal.master, price);

    // update animal so that previous owner gets earnings up until the purchase
    UpdateAnimal(animalId);

    // update ownership
    animal.master = msg.sender;

    setAnimalPrice(animal, price);
}

function ApplyJob(uint256 animalId, uint256 landId, uint8 jobIndex) {
    animal = animals[animalId];
    land = lands[landId];

    // require job to be free
    require(land.jobs[jobIndex] == 0);

    updateAnimal(animal);

    // first quit job if there is one
    if(animal.job != 0) {
        quitJob(animal);
    }

    // start worknig at the new job
    startJob(animalId, animal, landId, land, jobIndex);
}

function updateAnimal(Animal storage animal) {

    uint numBlocks = block.number-animal.lastUpdate;

    // DELETE should be done sep
    //taxAnimal(animal);

    // give master VOICE
    animal.master.voiceCredits += VC_PER_BLOCK * numBlocks;

    // feed the animal to full
    feedAnimal(animal, ENERGY_PER_BLOCK_BASE * numBlocks, MAX_ENERGY);

    // DELETE should be done sep
    //if(animal.job != 0) {
    //    work(animal)
    //}

    // ?? is it a problem if there are future updates in the same block#?
    // ?? maybe 1 action/user limitation (also means you can keep track of oldest animal more easily)
    animal.lastUpdate = block.number;
}

function feedAnimal(Animal storage animal, uint32 consumed, uint32 fill) {
    //TODO

    // todo energy refilled based on animal stats

    // first use potatoes

    // then use reserve energy

    // now use more potatoes to fill up reserve energy
    uint32 toFill = fill-animal.energy;
    if(toFill > 0) {
        numPot = toFill / ENERGY_PER_POTATO;
        min(numPot, animal.master.tokens)
    }
}

function payAnimal(Animal storage animal, address master, uint256 amount) {
    // todo fallback case if potatoes could not be borrowed
    masters.subBalance(master, amount);
    masters.addBalance(animal.master, amount);
}

// animal internal functions
function taxAnimal(Animal storage animal) {
    numBlocks = block.number-animal.lastTaxUpdate;
    levyTax(animal.master, law.animalTax, animal.value, numBlocks);
    animal.lastTaxUpdate = block.number;
}

function setAnimalPrice(Animal storage animal, uint256 price) {
    animal.price = price;
}

function animalIsUpdated(Animal storage animal) returns bool {
    return animal.lastUpdate == block.number;
}

function SetLandPrice(uint256 landId, uint256 price) {
    land = lands[landId];

    // must tax before setting price to ensure lazyness is correct
    taxLand(land);

    setLandPrice(land, price)
}

function setLandPrice(Land storage land, uint256 price) {
    land.price = price;
}


function PurchaseLand(uint256 landId, uint256 price) {
    land = lands[landId];

    // check for sufficient funds
    require(masters.balance(msg.sender) > price);
    masters.subBalance(msg.sender, price);
    masters.addBalance(land.owner, price);

    for(int i=0; i < land.workingAnimals.length; i++) {
        if(land.workingAnimals[i] != 0) {
            work(animals[land.workingAnimals[i]]);
        }
    }

    // update ownership
    land.owner = msg.sender;

    setLandPrice(land, price);
}

// land transactions
function UpdateLand(uint256 landId) {
    land = lands[landId];
    uint numBlocks = block.number-land.lastUpdate;

    // DELETE should be done sep
    //taxLand(land);

    updateEcologyPassive(land, numBlocks)


    land.lastUpdate = block.number;
}

function removeJob(Land storage land, uint jobIndex) {
    job = land.jobs[jobIndex]
    if (job != 0) {
        animal = animals[land.workingAnimals[jobIndex]]

        // boot the animal
        land.workingAnimals[jobIndex] = 0;
        animal.job = 0;

        // severance pay
        payAnimal(animal, land.master, law.severanceBlocks * job.wage);

    }
    land.jobs[jobIndex] = 0;
}
function createJob(Land storage land, uint jobIndex, Job jobDesc) {
    removeJob(land, jobIndex);
    land.jobs[jobIndex] = jobDesc;
}

// land internal functions
function taxLand(Land storage land) {
    numBlocks = block.number-land.lastTaxUpdate;
    levyTax(land.owner, law.landTax, land.value, numBlocks);
    land.lastTaxUpdate = block.number;
}

// animal<->land functions
function quitJob(Animal storage animal) {
    require(animalIsUpdated(animal));
    require(animal.job != 0);

    lands[animal.job.landId].workingAnimals[animal.job.jobIndex] = 0;
    animal.job = 0;
}

function startJob(uint256 animalId, Animal storage animal, uint256 landId, Land land, uint8 jobIndex) {
    require(animalIsUpdated(animal));
    require(land.workingAnimals[jobIndex] == 0);

    land.workingAnimals[jobIndex] = animalId;
    animal.job = Job{landId, jobIndex};


function work(Animal storage animal)
{
    blocksWorked = block.number - animal.job.lastWorkUpdate;
    if(blocksWorked == 0) {
        return;
    }

    Land storage land = lands[animal.job.landId];
    Job job = lands.jobs[animal.job.jobIndex];
    blocksWorked = block.number - animal.job.lastWorkUpdate;

    // update land ecology
    uint carbon = updateEcologyJob(land, job, blocksWorked);

    // todo energy conusmed based on job/animal stats
    energyConsumed = blocksWorked * ENERGY_PER_BLOCK_WORKED;
    feedAnimal(animal, energyConsumed, 0);

    // pay the animal
    payAnimal(animal, land.owner, job.wage * blocksWorked);

    // add output to master
    output = typeProductivity(job) * jobCompat(animal, job) * landCompat(land, job);
    masters.addItem(animal.owner, job.ItemType, output)

    animal.job.lastWorkUpdate = block.number;
}

// returns net carbon
function updateEcologyPassive(Land storage land, uint blocks)  returns uint  {
    //TODO local ecology

    //TODO global

    //carbon(land.master, amount);
}

// returns net carbon
function updateEcologyJob(Land storage land, Job job, uint blocks) returns uint {
    //TODO local ecology

    //TODO global

    //carbon(land.master, amount);
}

// lookup/compatability functions
function jobProductivity(Job job) pure returns float {
    if(job.itemType == CORN) {
        return 1.0;
    } else if (job.itemType == STUFF) {
        return 0.8;
    }
}

// where 1 means requirement is met
function statCompat(uint stat, uint req) returns float {
    if(stat <= req){
        // quadradtic scaling before req
        return (stat*stat)/(req*req);
    } else {
        // linear scaling at 1/2 factor of req
        return 1+(stat-req)/(2*req);
    }
}

// compatability functions
function jobCompat(AnimalStats animal, Job job) pure returns float {
    uint total = (job.strReq + job.dexReq + job.intReq + job.chrReq);
    return (statCompat(animal.str, job.strReq) * job.strReq +
        statCompat(animal.dex, job.dexReq) * job.dexReq +
        statCompat(animal.intel, job.intReq) * job.intelReq +
        statCompat(animal.charisma, job.chrReq) * job.chrReq) / total
}


struct Agriculture {
    uint sunIdeal;
    unit rainIdeal;
    uint topIdeal;
    uint tempIdeal;
}

function agricultureCompat(LandStats land, Agriculture job) pure returns float {
    int sun = land.sun - job.sunIdeal;
    int rain = land.rain - job.rainIdeal;
    int top = land.top - job.topIdeal;
    int temp = land.temp - job.tempIdeal;

    // closer to zero is better
    return sqrt(sun*sun + rain*rain + top*top + temp*temp)
}

struct Market {
    uint tokens;
    uint potatoes;
    mapping(address => uint) liquidity;
}

library MarketPlace {
    mapping(ItemType => Market);

    // TODO
    // based on uniswap
    //AddLiqudity()
    //RemoveLiquidity()
    //PotatoesToTokens()
    //TokensToPatotes()
}

MarketPlace globalMarketPlace;
