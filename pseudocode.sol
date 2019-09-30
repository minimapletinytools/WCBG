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

// TODO public policy proposal + voting to pass

uint TAX_DENOM = 10000000;
struct PublicPolicy {
    // tax is over tax/TAX_DENOM * <value> per block
    uint32 landTax;
    uint32 animalTax;

    // masters should have at least taxReserve/100000 * <taxation per block>
    uint16 taxReserve;


    // other parameters
    // severance?
    // insurance for failure to pay salary or
    // finders fee per block
    // finders fee bonus per overdue block
    // bankrupcy finders fee?
    // bankrupcy thresheld? (amonut owed > threshold*asset value)

}

struct Master {
    // todo use more efficient dense storage since # of times are finite
    mapping (ItemType => uint) items;
    uint256 tokens;
    uint256 publicDebt;

    // TODO total assets value (may cover tax reserve?)
    // TODO total harberger tax reserve liability (to ensure enough funds to pay all tax)
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
    function subBalance(address owner, uint256 value) {
        require(value > masters[owner].tokens);
        masters[owner].tokens -= value;
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
    // do we really need this? I don't think we do if we have public debt
    function checkReserve(address owner, uint32 tax, uint256 amount) returns bool {
        // TODO check if reserve funds are sufficient to cover increase in tax liability
        //taxLiability = tax/TAX_DENOM * amount
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
// returns amount of taxes that could not be paid due to insufficient balance
function levyTax(address master, uint16 tax, uint256 amount, uint blocks) returns uint256 {
    // there is some round off error, prob not a big deal
    taxPerBlock = tax/TAX_DENOM * amount;
    taxAmount =  taxPerBlock * blocks;
    old = masters.balance(master);
    if old < taxAmount {
        masters.subBalance(master, taxAmount);
        return taxAmount-old;
    }
    masters.setBalance(master, old-taxAmount);
    return 0;
}

function accrueDebt(address owner, uint256 amountOwed) {
    // TODO
    // IDK I guess add some sort of public debt?
    // if public debt exceeds total value of all assets owed, then player really goes bankrupt and relinquishes all assets to the government for auction.

    Master storage master = masters[owner];
    master.debt += amountOwed;

    // TODO handle force bankrupcy
    //if(master.debt > master.totalAssetValue*law.bankruptThreshold)

}

// animal transactions
function SetAnimalPrice(uint256 animalId, uint256 price) external {
    animal = animals[animalId];

    // ?? do we really need this? I don't think we do if we have public debt
    if(price > animal.price) {
        if(!masters.checkReserve(animal.master, law.animalTax, price - animal.price)) {
            return;
        }
    }

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

    // ?? do we really need this? I don't think we do if we have public debt
    // check tax reserves are sufficient
    if(!masters.checkReserve(msg.sender, law.animalTax, price)) {
        return;
    }

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

    // early exit if nothing will happen
    if(block.number == animal.lastUpdate) {
        return;
    }

    // ?? do we need this?
    taxAnimal(animal);

    // TODO update hunger

    // update work
    if(animal.job != 0) {
        work(animal, lands[animal.job.landId], animal.job.jobIndex);
    }

    // ?? is it a problem if there are future updates in the same block#?
    // ?? maybe 1 action/user limitation (also means you can keep track of oldest animal more easily)
    animal.lastUpdate = block.number;
}


// animal internal functions
function taxAnimal(Animal storage animal) {
    owed = levyTax(animal.master, law.animalTax, animal.value, block.number-animal.lastTaxUpdate);
    if(owed > 0) {
        accrueDebt(animal.master, owed);
    }
    animal.lastTaxUpdate = block.number;
}

function setAnimalPrice(Animal storage animal, uint256 price) {
    animal.price = price;
    // TODO update master tax reserve liability
}

function animalIsUpdated(Animal storage animal) returns bool {
    return animal.lastUpdate == block.number;
}

//function SetPrice(uint256 landId, uint256 price) {

// land transactions
function UpdateLand(uint256 landId) {
    // TODO finish

    land = lands[landId];

    taxLand(land);

    // ?? TODO do we update all jobs or no

    // ?? TODO update ecology (or does this happen when jobs get updated?)

    land.lastUpdate = block.number;
}

function removeJob(Land storage land, uint jobIndex) {
    job = land.jobs[jobIndex]
    if (job != 0) {
        animal = animals[land.workingAnimals[jobIndex]]

        // boot the animal
        land.workingAnimals[jobIndex] = 0;
        animal.job = 0;

        // TODO severance pay
    }
    land.jobs[jobIndex] = 0;
}
function createJob(Land storage land, uint jobIndex, Job jobDesc) {
    removeJob(land, jobIndex);
    land.jobs[jobIndex] = jobDesc;
}

// land internal functions
//function taxLand(Land storage land) {



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
}

function work(Animal storage animal, Land land, Job job)
{
    // TODO check that animal has enough energy to work
        // do something if animal can't work

    output = typeProductivity(job) * jobCompat(animal, job) * landCompat(land, job);
    masters.addItem(animal.owner, job.ItemType, output)

    // TODO modify animal stats
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
