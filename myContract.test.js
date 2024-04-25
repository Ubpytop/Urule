const MyContract = artifacts.require("MyContract");

contract("MyContract", (accounts) => {
  it("should transfer ownership correctly", async () => {
    const myContractInstance = await MyContract.deployed();
    const newOwner = accounts[1];
    await myContractInstance.transferOwnership(newOwner);
    const contractOwner = await myContractInstance.owner();
    assert.equal(contractOwner, newOwner, "Ownership not transferred correctly");
  });
});
