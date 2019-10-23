TODO UPDATE

## Potato Game Design Outline
Potato Game takes place in Potato Land

### Potatoes
Potatoes are the intrinsic base currency of the game. All economic transactions are handled in potatoes. These same potatoes are also an agricultural food product obtainable through labor which is explained in more detail later.

### Corporations
Corporations are the players of the game. Corporations owns resources and assets. Players interact with the game by sending signed transactions to command the master's actions. Potatoes are automatically deducted from the master's holdings in order to pay taxes on their assets.

### Assets
Assets are special public/private resources in Potato Land. They are public goods that are privately owned by masters through the potato harberger tax system. Corporations choose a price for their assets. Any other master can purchase the asset for the set price. A master pays a tax to the DAO government that is proportional to the price they set. There are two types of assets in the game:

#### Land
Potato Land is split into a `25x25` grid. Each cell in the grid is a unit of land. Each unit of land is distinct. Land can host jobs and create economic output when animals work the jobs. The output is dependent on the land traits and infrastructure. Land can be developed to host infrastructure or improve its traits. Land traits can also be altered due to environmental factors.

Each unit of land has the following quantified traits:

- fertility
- natural resources
- pollution
- topology
- humidity
- rain
- sun
- fauna
- diversity

#### Animals
Animals are the residents of Potato Land. They live, work and grow together in Potato Land. Animals can work jobs in exchange for potatoes. Their economic output is dependent on its traits. Animals must eat in order to sustain their energy which is required to work. Animals can grow (alter its traits) based on dietary choices or through service providers.

When an animal is owned by a master, it automatically eats from the master's resources based on the diet set by its master. All other actions taken by the animal are decided by its master.

Animals have the following quantified traits:

- strength
- intelligence
- cuteness
- dexterity
- dietary preference

?? Animals can obtain knowledge through research jobs which allows them to build better infrastructure and perform new services.

Animals can also vote on proposals using VOICE credits they obtain over time. See the Government section below

### Resources

Resources are similar to assets but are fungible and untaxed. They can held as savings or spent by masters and their animals. All resources can be bought and sold in the marketplace which is explained later. Resources are produced through labor.

- Food: an agricultural product that is primarily used as sustenance for animals.
- Potatoes: an exceptional type of food renowned for its utility and liquidity. While potatoes are the most caloric efficient foodstuff available, it is bland and does not contribute to an animal's growth. It is widely accepted as the currency of Potato Land.
- Junk: useless junk that you can collect
- Parts: used to build infrastructure on land

### Jobs and Labor
All economic output in Potato Land is produced through jobs. Corporations become employers if they create jobs on the land they own. Animals can work jobs in exchange for wages paid for by the employer. The economic output goes to the employer and the wages goes to the employed animal's master. N.B. The animal gets nothing but must be fed by its owner so that it can have energy to work. The output of a job is dependent on the job, the land's traits, and the animals traits. Some jobs require special skills from the animal. Some jobs require infrastructure that must be developed on the land. Other infrastructure can improve the efficiency of labor. Most jobs have environmental impact.

In order to a create a job, the employer creates an opening and animals must apply. The employer can at any point hire any animal that has applied. The employer can set productivity requirements to automatically hire the first applicant that meets the requirements.

#### Resource Production
Resource producing jobs generate resources. They all have environmental impact. Some resource producing jobs may require input. Resource producing jobs can be greatly affected by infrastructure. These jobs include:
- Agriculture: generates food products
- Mining: extracts natural resources from the land to generate raw materials
- Manufacturing: consumes materials to produce various goods

#### ?? Service Jobs
Service jobs create services that other animals may employ. Service jobs only generate revenue if other animals use the services.

<TODO cut this?>

#### Single Task Jobs
Single task jobs expire as soon as the task is done. There are two types of single task jobs:
- Research Jobs: <TODO figure out how knowledge works>
- Construction Jobs: construction jobs take parts and raw material and builds infrastructure on the land hosting the job

### ?? Special Skills
Animals can learn special skills that enable them to do new jobs

<TODO this is complicated but pretty cool. maybe cut together with public grants>

### Environment
With such diverse fauna, it's unsurprising that Potato Land at genesis is a vibrant healthy environment with plenty of natural resources to fuel growth and development. Natural resources are affected by extractive labor as described in the Jobs and Labor section. Environmental variables change naturally over time or directly based on animal activity. Some natural resources are finite. Labor productivity and animal health may be directly effected by environmental variables.

### Government
Potato Land is governed by a decentralized autonomous organization. This organization set policies that are followed through immediately and automatically in code. All taxes go to the government's treasuries and these funds are spend in accordance to its policies. Animals of Potato Land all have equal voice in the government. They earn VOICE credits equally over time and may spend as many or as few of these credits as they please to vote on policies. They weight of their vote is equal to the square root of votes they cast.

#### Public Policy

Public policy can be changed through proposals. After a voting period, proposals are passed if their weighted total of YES votes are greater than NO votes and the total number of votes exceed a minimum voting threshold. Once a proposal passes, the policy is updated automatically and immediately. A certain number of potatoes must be deposited for a proposal to be created. The deposit is returned if the proposal passes.

The Potato Land government has the following public policy variables:

- animal tax
- land tax
- mandatory severance pay
- universal basic income
- employee insurance (for employers who do not have funds to pay wages)
- bankruptcy threshold (maximal debt allowed before assets are repossessed)
- <todo tax reserve liability or public debt>

As a blockchain game that relies on lazy evaluation, there are also policies related to platform externalities:

- finders fee per block updated
- finders fee per block after bankruptcy

#### ?? Public Grants
<I think this is too complicated and can probably be replaced with some other mechanism>

To incentivize public projects benefiting all masters of Potato Land, the government can issue grants. Anyone can create a new grant and apply for it. Animals vote simultaneously to authorize the grant and choose the winning applicant.

### The Market
All resources (produced through labor) can be bought and sold in the global marketplace. The marketplace is automated with an X*Y=K <LMSR?> market maker. Using the marketplace burns potatoes per unit weight of goods transported. The marketplace also taxes all transactions in potatoes based on taxation policy set by the government.
