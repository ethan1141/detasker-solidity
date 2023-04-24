import { BigNumber } from "ethers";

export class Rating {
  id: BigNumber = BigNumber.from("0");
  rating: BigNumber = BigNumber.from("0");
  review: string = "";
  jobId: BigNumber = BigNumber.from("0");
}
