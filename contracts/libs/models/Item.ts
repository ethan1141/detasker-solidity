import { Address } from "wagmi";
import { Job } from "./Job";
import { Skill } from "./Skill";
import { Dispute } from "./Dispute";
import { Freelancer } from "./Freelancer";
import { BigNumber } from "ethers";

export class Item {
  address: Address = "0x";
  jobs: Job[] = [];
  ratings: Job[] = [];
  skills: Skill[] = [];
  dispute: Dispute[] = [];
  freelance: Freelancer[] = [];
  jobCount: BigNumber = BigNumber.from("-1");
  freelanceCount: BigNumber = BigNumber.from("-1");
  ratingCount: BigNumber = BigNumber.from("-1");
  tagCount: BigNumber = BigNumber.from("-1");
  skillCount: BigNumber = BigNumber.from("-1");
  userCount: BigNumber = BigNumber.from("-1");
  bnbToken: Address = "0x";
}
