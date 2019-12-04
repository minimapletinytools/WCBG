# Ecology

## Global Ecology
Global pollution is quantified into a single variable: atmospheric carbon dioxide levels


-increases based on job impact
-recovers X/block per unit land based on that land's flora

## Land Ecology
Land ecology is quantified into several variables which affect each other as well

#### pollution
- recovers X/block
  - faster based on fauna
- increases based on job impact
#### fertility
- recovers X/block
  - faster based on fauna
#### flora
- recovers based on logistic function
- recovery effected by fertility
#### fauna
- recovers based on logistic function
  - faster based on neighboring block fauna
  - faster based on flora
  - slower based on pollution
- decreases based on job impact
#### fish [TODO delete, just roll into fauna]
- recovers based on logistic function
  - faster/slower based on neighboring fish
  - slower based on pollution
- decreases based on job impact

## Land Agricultural Productivity
While each crop has its own niche requirements, broadly speaking agricultural productivity is a function of fertility. Fertility can be attained in two ways: natural and artificial.

Natural fertility is simply the land's fertility. It may decrease depending on the agricultural technique used.

Artificial fertility is attained by adding fertilizers. Fertilizers may greatly boost fertility for each crop it is applied to. Fertilizer can be attained through manufacturing and have a wide variety of effects. For example, petroleum based fertilizers are incredibly effective and incur pollution on the land each time it's used.

A land's natural fertility, flora, and diversity mutually improve each others. Their recovery is negatively effected by increased pollution and they also help improve pollution recovery.
