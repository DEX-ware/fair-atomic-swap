// Copyright (c) 2018 BetterToken BVBA
// Use of this source code is governed by an MIT
// license that can be found at https://github.com/rivine/rivine/blob/master/LICENSE.

var NonRiskySpeculativeAtomicSwap = artifacts.require("./NonRiskySpeculativeAtomicSwap");

module.exports = function (deployer) {
  // deployment steps
  deployer.deploy(NonRiskySpeculativeAtomicSwap);
};