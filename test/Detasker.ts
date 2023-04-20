import { assert } from "chai";
import { Detasker, Detasker__factory } from "../typechain-types";
import { ethers } from "hardhat";
import { BigNumber } from "ethers";

describe("Detasker", function () {
  let detasker: Detasker__factory, contract: Detasker, owner: any, fac;
  beforeEach(async function () {
    [owner] = await ethers.getSigners();
    // console.log("testing... deploying contract...");

    detasker = await ethers.getContractFactory("Detasker");

    contract = await detasker.deploy(owner.address);
  });
  it("Firstly it should be set to the owner", async function () {
    assert.equal(await contract.getOwner(), owner.address);
  });

  it("Add a user", async function () {
    const user: Detasker.NewProfileStruct = {
      name: "ethan",
      freelance: ,
      email: "ethnruss@gmail.com",
      image: "www",
      socials: [],
      showcaseWork: [],
      skills: [],
    };
    contract.createUser(owner.address, user);
    assert.equal((await contract.getUserCount()).toNumber(), 1);
  });

  it("30 days conformation days", async function () {
    assert.equal((await contract.timeForConformation()).toNumber(), 2.592e6); // calc off google
  });
});
