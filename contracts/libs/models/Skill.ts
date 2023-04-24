import { BigNumber } from "ethers";

export class Skill {
  id: BigNumber = BigNumber.from("0");
  profileId: BigNumber = BigNumber.from("0");
  skill: string = "";
  skillName: string = "";
  url: string = "";
  user: string = "0x0000000000000000000000000000000000000000";
}
