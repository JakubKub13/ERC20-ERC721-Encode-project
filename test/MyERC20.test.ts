import { ethers } from "hardhat";
import { expect } from "chai";
import { MyERC20 } from "../typechain-types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("MyERC20 Token", function () {
    let owner: SignerWithAddress;
    let jacob: SignerWithAddress;
    let martin: SignerWithAddress;
    let myERC20Token: MyERC20;

    beforeEach(async () => {
        const MyERC20Token = await ethers.getContractFactory("MyERC20");
        [owner, jacob, martin] = await ethers.getSigners();
        myERC20Token = await MyERC20Token.deploy() as MyERC20;
    });

    describe("Initialization", async () => {
        it("Should deploy without errors", async () => {
            expect(myERC20Token).to.be.ok
        });
    })
})