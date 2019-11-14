# Potato Game Design Document (MVP version)
Potato Game takes place in Potato Land

## Potatoes
Potatoes are the intrinsic base currency of the game. All economic transactions are handled in potatoes. These same potatoes are also an agricultural food product obtainable through labor which is explained in more detail later.

## Corporations
Corporations are the players of the game. Corporations owns resources and assets. Players interact with the game by sending signed transactions to command the master's actions. Potatoes are automatically deducted from the master's holdings in order to pay taxes on their assets. Corporation attain VOICE credits per animal per unit time elapsed which can be used to vote on public policy proposals.

## Assets
Assets are special public/private resources in Potato Land. They are public goods that are privately owned by masters through the potato harberger tax system. Corporations choose a price for their assets. Any other master can purchase the asset for the set price. A master pays a tax to the DAO government that is proportional to the price they set. There are two types of assets in the game:

### Land
Potato Land is split into a `25x25` grid. Each cell in the grid is a unit of land. Each unit of land is distinct. Land can host jobs and create economic output when animals work the jobs. The output is dependent on the land traits and infrastructure. Land can be developed to host infrastructure or improve its traits. Land traits can also be altered due to environmental factors.

Each unit of land has the following quantified traits:

- fertility
- natural resources
- pollution
- topology
- rain
- sun
- temperature
- flora
- diversity

### Animals
Animals are the residents of Potato Land. They live, work and grow together in Potato Land. Animals can work jobs in exchange for potatoes. Their economic output is dependent on its traits. Animals must eat in order to sustain their energy which is required to work. Animals can grow (alter its traits) based on dietary choices or through service providers.

Animals have the following quantified traits:

- strength
- intelligence
- cuteness
- dexterity
- dietary preference

### Resources

Resources are similar to assets but are fungible and untaxed. They can held as savings or spent by masters and their animals. All resources can be bought and sold in the marketplace which is explained later. Resources are produced through labor.

- Food: an agricultural product that is primarily used as sustenance for animals.
- Potatoes: an exceptional type of food renowned for its utility and liquidity. While potatoes are the most caloric efficient foodstuff available, it is bland and does not contribute to an animal's growth. It is widely accepted as the currency of Potato Land.
- Junk: useless junk that you can collect
- Parts: used to build infrastructure on land


## Resources
Resources are similar to assets but are fungible and untaxed. They can held as savings or spent by masters and their animals. All resources can be bought and sold in the marketplace which is explained later. Resources are produced through labor.

- Food: an agricultural product that is primarily used as sustenance for animals.
- Potatoes: an exceptional type of food renowned for its utility and liquidity. While potatoes are the most caloric efficient foodstuff available, it is bland and does not contribute to an animal's growth. It is widely accepted as the currency of Potato Land.
- Junk: useless junk that you can collect
- Parts: used to build infrastructure on land

## Jobs and Labor
All economic output in Potato Land is produced through jobs. Corporations become employers if they create jobs on the land they own. Animals can work jobs in exchange for wages paid for by the employer. The economic output goes to the employer and the wages goes to the employed animal's master. N.B. The animal gets nothing but must be fed by its owner so that it can have energy to work. The output of a job is dependent on the job, the land's traits, and the animals traits. Some jobs require special skills from the animal. Some jobs require infrastructure that must be developed on the land. Other infrastructure can improve the efficiency of labor. Most jobs have environmental impact.

In order to a create a job, the employer creates an opening and animals must apply. The employer can at any point hire any animal that has applied. The employer can set productivity requirements to automatically hire the first applicant that meets the requirements.

### Resource Production
Resource producing jobs generate resources. They all have environmental impact. Some resource producing jobs may require input. Resource producing jobs can be greatly affected by infrastructure. These jobs include:
- Agriculture: generates food products
- Mining: extracts natural resources from the land to generate raw materials
- Manufacturing: consumes materials to produce various goods

### Service Jobs
Service jobs create services that other animals may employ. Service jobs only generate revenue if other animals use the services.

### Single Task Jobs
Single task jobs expire as soon as the task is done. There in type of single task jobs:
- Construction Jobs: construction jobs take parts and raw material and builds infrastructure on the land hosting the job. The speed of construction depends on the stats of the animal.

## Infrastructure
Each unit of land has several lots that can support infrastructure that is built with a single task job.

### Job Infrastructure
Infrastructure is built by corporations from and processed material produced through labor. Some jobs are made possible and others more efficient with the right infrastructure.

## Marketplaces
All resources (produced through labor) can be bought and sold in marketplaces using potatoes. The marketplace is automated with an constant product (X*Y=K) market maker. Any corporation may build a marketplace on land they own. Anyone can add liquidity in exchange for transaction fees. The corporation who owns the land may set this transaction fee as well as a transaction fee for itself. The government may also levy its own tax. All fees and taxes are paid in potatoes. The marketplace is based on Uniswap.

## Government
Potato Land is governed by a decentralized autonomous organization. This organization set policies that are followed through immediately and automatically in code. All taxes go to the government's treasury and these funds are spend in accordance to its policies. Animals of Potato Land earn VOICE credits for their corporations equally over time. Corporations may spend as many or as few of these credits as they please to vote on policies. The weight of their vote is equal to the square root of votes they cast.

### Public Policy
Public policy can be changed through proposals. After a voting period, proposals are passed if their weighted total of YES votes are greater than NO votes and the total number of votes exceed a minimum voting threshold. Once a proposal passes, the policy is updated automatically and immediately. Each term, the proposals with the top deposits are voted on. The deposit is returned if the proposal passes.

The Potato Land government has the following public policy variables:

- animal tax
- land tax
- ?? marketplace tax
- ?? marketplace owner maximum transaction fee
- ?? marketplace liquidity minimum transaction fee
- ?? animal/land sales profit tax
- mandatory severance pay
- universal basic income
- employee insurance (for employers who do not have funds to pay wages)
- maximum public debt (debt can accrue if a corporation does not have enough to pay for taxes, corporations are forced into bankruptcy if they exceed this amount of debt)
- environmental
  - carbon tax

As a blockchain game that relies on lazy evaluation, there are also policies related to the implementation details:

- finders fee per block updated
- finders fee per block after bankruptcy

### Public Grants
To incentivize public projects benefiting all masters of Potato Land, the government can issue grants. Anyone can create a new grant and apply for it. Corporations vote simultaneously to authorize the grant and choose the winning applicant.

## Environment
With such diverse fauna, it's unsurprising that Potato Land at genesis is a vibrant healthy environment with plenty of natural resources to fuel growth and development. Natural resources are affected by extractive labor as described in the Jobs and Labor section. Environmental variables change naturally over time or directly based on animal activity. Some natural resources are finite. Labor productivity and animal health may be directly effected by environmental variables.
