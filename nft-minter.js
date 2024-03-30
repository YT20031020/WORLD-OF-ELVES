import { ethers, JsonRpcProvider } from "ethers";
import fs from 'fs';
import dotenv from 'dotenv';
dotenv.config("./.env");

export async function mint(address, uri) {
    const provider = new JsonRpcProvider(process.env.RPC);
    const signer = await provider.getSigner()

    const MyNFTAbi = JSON.parse(fs.readFileSync('./abis/MyNFT.json'));
    const MyNFTContract = new ethers.Contract(process.env.NFT, MyNFTAbi, signer);

    const result = await MyNFTContract.safeMint(address, uri);
    console.log(result.hash);
}

