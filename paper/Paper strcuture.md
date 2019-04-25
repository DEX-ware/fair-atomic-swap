# Paper structure

## Introduction

- What is double-spending attack
- Introduce the following
  - PoW
  - `honest majority` security assumption
  - `incentive mechanism`
- Our Contribution
  - `honest majority` security assumption is flawed
  - `incentive mechanism` is not incentive-compatible
  - the model to support our contribution

## Security model

- Background of PoW (and its security model)
  - The PoW processing
  - Difficulty param
  - Confirmation blocks
  - Hash functions in PoW
  - Info propagation mechanism
  - (mention assumptions here)
- system model (what real world has)
  - facts
    - multiple blockchains, mining power not bounded to blockchains
    - cloud mining power
  - assumptions
- Threat model (what the adversary can do)
  - rational adversary
  - profit-driven strategy
    - migrate mining power
    - renting mining power

NOTE:

- system model
  - pow
  - double-spending
  - considered attacks
- formalization

## Formalization

- Definitions
  - double-spending attacks
  - 51\% attacks
  - their relationship
- Our proposed attacks
  - `mining power migration attack`
  - `cloud mining attack`
- Model (MDP)

## Analysis

- Experimental Methodology
  - Hw/Sw
  - MDP
- Impact of Parameters
  - Mining Status (D2, h2)
    - D2 dev/h2 inc => rev inc
  - Incentives (tx, R2)
    - tx inc/R2 dec => rev inc
  - nConfirm
    - nConfirm inc => rev dec
  - gamma
    - nConfirm inc => rev inc
  - Renting price (pr) (only for cloud mining)
    - pr inc => rev dec
- Real World Cases
  - Mining Power Migration Attack
    - Figure for BTC/BCH, ETH/ETC
  - Cloud Mining Attack
    - Table for all PoW coins

## 51% Attack on ETC

- Attack details
- Analysis



TODO:
1. contribution summary