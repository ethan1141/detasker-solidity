import { BigNumber } from "ethers";

export class Freelancer {
  id: BigNumber = BigNumber.from("0");
  isFreelancer: boolean = false;
  active: boolean = false;
  mainSkills: string = "";
  skillsId: BigNumber[] = [];
}
