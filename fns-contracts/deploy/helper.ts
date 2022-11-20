import { FeeData } from "@ethersproject/providers";
import { keccak256, toUtf8Bytes } from "ethers/lib/utils";

// BlockGasLimit / 10 = 1000000000
export const DefaultGasLimit = 500000000;

export const txParams = (feeData: FeeData) => {
  return {
    gasLimit: DefaultGasLimit,
    maxPriorityFeePerGas: feeData.maxPriorityFeePerGas!,
  };
};

export const RootNode = "0x0000000000000000000000000000000000000000000000000000000000000000";
export const AddressZero = "0x0000000000000000000000000000000000000000";

export const labelhash = (label: string): string => keccak256(toUtf8Bytes(label));

export const isEqualIgnoreCase = (a: string, b: string): boolean => a.toLowerCase() === b.toLowerCase();