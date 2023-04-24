import { BigNumber, ethers } from "ethers";
import { Address } from "wagmi";

export class Job {
  id: BigNumber = BigNumber.from("0");
  hasFunds: boolean = false;
  profileId: BigNumber = BigNumber.from("0");
  title: string = "";
  description: string = "";
  documents: string[] = [];
  owner: string = "0x0000000000000000000000000000000000000000";
  requester: string = "0x0000000000000000000000000000000000000000";
  date: BigNumber = BigNumber.from("0");
  datePaid: BigNumber = BigNumber.from("0");
  img: string[] = [];
  requestedPaymentAmount: BigNumber = BigNumber.from("0");
  token: string = "0x0000000000000000000000000000000000000000";
  tags: string[] = [];
  publish: boolean = false;
  completed: boolean = false;
  paid: boolean = false;
  assigned: boolean = false;
  dateCompleted: BigNumber = BigNumber.from("0");
  postedDate: BigNumber = BigNumber.from("0");
  datePublished: BigNumber = BigNumber.from("0");
  dispute: string[] = [];
  deleted: boolean = false;
}
