import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:riverpod/riverpod.dart';

import '../constants.dart';

final ethereumUtilsProvider = Provider((ref) => EthereumUtils());

class EthereumUtils {
  http.Client httpClient;
  Web3Client ethClient;
  String rpcUrl = 'http://127.0.0.1:7545';
  String privateKey =
      '3c3d118cf57bc21eff80195a7b4ab0e03073b1f32b3cf67730cefc15bf22b1cc';
  Credentials credentials;
  EthereumAddress myAddress;

  Future<void> initialSetup() async {
    httpClient = http.Client();
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();
    await getDeployedContract();
    await getContractFunctions();
  }

  Future<void> getCredentials() async {
    credentials = EthPrivateKey.fromHex(privateKey);
    myAddress = await credentials.extractAddress();
  }

  String abi;
  EthereumAddress contractAddress;

  Future<void> getDeployedContract() async {
    String abiString =
        await rootBundle.loadString('assets/contracts_abis/Investment.json');

    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
  }

  DeployedContract contract;
  ContractFunction getBalanceAmount,
      getDepositAmount,
      addDepositAmount,
      withdrawBalance;
  Map<String, ContractFunction> functionMap;

  Future<void> getContractFunctions() async {
    contract = DeployedContract(
        ContractAbi.fromJson(abi, "Investment"), contractAddress);

    getBalanceAmount = contract.function('getBalanceAmount');
    getDepositAmount = contract.function('getDepositAmount');
    addDepositAmount = contract.function('addDepositAmount');
    withdrawBalance = contract.function('withdrawBalance');

    functionMap = {
      Constants.getBalanceAmount: getBalanceAmount,
      Constants.getDepositAmount: getDepositAmount,
      Constants.addDepositAmount: addDepositAmount,
      Constants.withdrawBalance: withdrawBalance,
    };
  }

//READ FROM BLOCKCHAIN
  Future<List<dynamic>> readContract(
      String functionName, List<dynamic> functionArgs) async {
    var queryResult = await ethClient.call(
      contract: contract,
      function: functionMap[functionName],
      params: functionArgs,
    );
    return queryResult;
  }

//WRITE TO THE BLOCKCHAIN
  Future<void> writeToContract(
    String functionName,
    List<dynamic> functionArgs,
  ) async {
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: functionMap[functionName],
        parameters: functionArgs,
      ),
    );
  }
}
