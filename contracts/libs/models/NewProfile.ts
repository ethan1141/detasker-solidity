import { BigNumber } from "ethers";
import { Freelancer } from "./Freelancer";
import { Social } from "./Social";
import { ShowcaseWork } from "./ShowcaseWork";
import { Skill } from "./Skill";

export class NewProfile {
  name: string = "";
  email: string = "";
  freelance: Freelancer = new Freelancer();
  image: string = "";
  socials: Social[] = [];
  showcaseWork: ShowcaseWork[] = [];
  skills: Skill[] = [];
}
