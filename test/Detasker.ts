import { assert } from "chai";
import { Detasker, Detasker__factory } from "../typechain-types";
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { NewProfile } from "../contracts/libs/models/NewProfile";
import { Job } from "../contracts/libs/models/Job";
import { Skill } from "../contracts/libs/models/Skill";
import { Rating } from "../contracts/libs/models/Rating";

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
    const p = new NewProfile();
    await contract.createUser(owner.address, p);
    // console.log(await contract.users(owner.address));

    assert.equal((await contract.getUserCount()).toNumber(), 1);
  });

  it("30 days conformation days", async function () {
    assert.equal((await contract.timeForConformation()).toNumber(), 2.592e6); // calc off google
  });
  it("add a job to bob", async function () {
    const p = new NewProfile();
    const j = new Job();
    await contract.createUser(owner.address, p);
    await contract.createJob(owner.address, j as unknown as Detasker.JobStruct);
    // console.log(await contract["getJobById(uint256)"](0));
    assert.equal(await contract.getJobCount(), 1); // calc off google
  });
  it("Add a skill to bob", async function () {
    const p = new NewProfile();
    const j = new Job();
    const s = new Skill();
    await contract.createUser(owner.address, p);
    await contract.createJob(owner.address, j as unknown as Detasker.JobStruct);
    await contract.createSkill(
      owner.address,
      s as unknown as Detasker.SkillStruct
    );
    console.log(await contract.getSkill(0));
    assert.equal(await contract.getSkillCount(), 1); // calc off google
  });
  it("assign ethan to bob's job and ethan to give feedback for bob", async function () {
    const p = new NewProfile();
    p.name = "Bob";
    const p1 = new NewProfile();
    p1.name = "Ethan";
    const j = new Job();
    j.title = "Bob's job";
    j.publish = true;
    j.requestedPaymentAmount = BigNumber.from("002");
    j.paid = true;
    j.completed = true;
    const s = new Skill();
    await contract.createUser(owner.address, p);
    await contract.createUser("0x81e70AAF7475AabA6D919e3A889b6D94C792c8A3", p1);
    await contract.createJob(owner.address, j as unknown as Detasker.JobStruct);
    await contract.createSkill(
      owner.address,
      s as unknown as Detasker.SkillStruct
    );
    await contract.assignJob("0x81e70AAF7475AabA6D919e3A889b6D94C792c8A3", 0);
    const r = new Rating();
    r.jobId = BigNumber.from("1");
    r.rating = BigNumber.from("5");
    r.review = "excellant results";
    await contract.completeJob(0, {
      value: ethers.utils.parseEther("0.002"),
    });
    await contract.giveFeedback(owner.address, r);

    console.log(await contract["getJobById(uint256)"](0));
    const ra = await contract.getRatingsArray(
      "0x81e70AAF7475AabA6D919e3A889b6D94C792c8A3"
    );
    assert.equal(ra.length, 1); // calc off google
  });
});
