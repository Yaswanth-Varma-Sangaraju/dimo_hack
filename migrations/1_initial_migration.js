const RentablePets = artifacts.requie("RentablePets");

module.exports = function(deployer){
    deployer.deploy (RentablePets);

};