//const SequentialFunction = artifacts.require("SequentialFunction");
const SequentialHashing = artifacts.require("HashVerifier");
const RefereeContract = artifacts.require("Referee");

module.exports = function (deployer){
	//deployer.deploy(SequentialFunction);
	//deployer.link(SequentialFunction, SequentialHashing);
	deployer.deploy(SequentialHashing);
	deployer.link(SequentialHashing, RefereeContract);
	deployer.deploy(RefereeContract);
};
