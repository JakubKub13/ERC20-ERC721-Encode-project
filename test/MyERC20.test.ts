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

        it("Should have correct name", async () => {
            expect(await myERC20Token.name()).to.eq("MyERC20Token")
        });

        it("Should have no supply after deployment", async () => {
            let startingTotalSupply = await myERC20Token.totalSupply();
            let formatedStartingTotalSupply = startingTotalSupply.toNumber()
            expect(formatedStartingTotalSupply).to.eq(0);
        });
    });

    describe("Test minter role", async () => {
        it("Should grant owner role to the deployer", async () => {
            let minter = await myERC20Token.MINTER_ROLE();
            await myERC20Token.grantRole(minter, owner.address);
            let startBalanceOwner = await myERC20Token.balanceOf(owner.address);
            let formattedStartBalanceOwner = startBalanceOwner.toNumber()
            expect(formattedStartBalanceOwner).to.eq(0);
            await myERC20Token.mint(owner.address, 50);
            let afterMintBalanceOwner = await myERC20Token.balanceOf(owner.address);
            let formattedAfterMintBalanceOwner = afterMintBalanceOwner.toNumber();
            let afterMintTotalSupply = await myERC20Token.totalSupply();
            let formattedAfterMintTotalSupp = afterMintTotalSupply.toNumber();
            expect(formattedAfterMintBalanceOwner).to.eq(50);
            expect(formattedAfterMintTotalSupp).to.eq(50);
        });

        it("Should revert when non-minter tries to mint tokens", async () => {
            await expect(myERC20Token.connect(jacob).mint(martin.address, 20)).to.be.revertedWith("MyERC20: Caller is not a minter")
        })
    })
})