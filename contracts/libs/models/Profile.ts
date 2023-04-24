import { BigNumber } from "ethers";
import { Social } from "./Social";

export class Profile {
  id: BigNumber = BigNumber.from("0");
  freeLanceId: BigNumber = BigNumber.from("0");
  name: string = "";
  email: string = "";
  socials: Social[] = [];
  signedUp: BigNumber = BigNumber.from("0");
  image: string = "";
  jobsId: BigNumber[] = [];
  ratings: BigNumber[] = [];
}
