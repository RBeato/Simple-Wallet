import 'dart:async';
import 'dart:convert';

import 'package:basic_wallet/models/wallet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:web_socket_channel/io.dart';

final ethereumUtilsProvider = Provider((ref) => EthereumUtils());

enum SCEvents {
  Balance,
}

class EthereumUtils {
  http.Client _httpClient;
  Web3Client _ethClient;
  String _rpcUrl = 'HTTP://192.168.1.79:7545';
  String _wsUrl = 'ws://192.168.1.79:7545';
  String privateKey = dotenv.env['GANACHE_PRIVATE_KEY'];
  Credentials credentials;

  String abi;
  EthereumAddress contractAddress;
  DeployedContract contract;
  var decoded;
  WalletModel wallet;

  void initialSetup() async {
    _httpClient = http.Client();
    _ethClient = Web3Client(_rpcUrl, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
  }

  Future listenContract() async {
    contract = await _getContract();
    listenEvent();
    return decoded;
  }

  StreamSubscription listenEvent() {
    var events = _ethClient.events(FilterOptions.events(
      contract: contract,
      event: contract.event('BalanceChange'),
    ));
    return events.listen((FilterEvent event) {
      if (event.topics == null || event.data == null) {
        return;
      }
      decoded = contract
          .event('BalanceChange')
          .decodeResults(event.topics, event.data);
      print("Listen Event: $decoded");
    });
  }

  Future<DeployedContract> _getContract() async {
    Completer<DeployedContract> completer = Completer();
    await rootBundle
        .loadString('assets/contracts_abis/Investment.json')
        .then((abiString) {
      var abiJson = jsonDecode(abiString);
      abi = jsonEncode(abiJson['abi']);
      contractAddress =
          EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
      contract = DeployedContract(
          ContractAbi.fromJson(abi, "Investment"), contractAddress);
      completer.complete(contract);
    });
    return completer.future;
  }

  Future<List<dynamic>> readContract(
      String functionName, List<dynamic> functionArgs) async {
    DeployedContract contract = await _getContract();
    var queryResult = await _ethClient.call(
      contract: contract,
      function: contract.function(functionName),
      params: functionArgs,
    );

    print("queryResult $queryResult");
    return queryResult;
  }

  Future<void> writeToContract(
    String functionName,
    List<dynamic> functionArgs,
  ) async {
    try {
      credentials = EthPrivateKey.fromHex(privateKey);
      DeployedContract contract = await _getContract();
      await _ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: contract.function(functionName),
          parameters: functionArgs,
        ),
      );
    } catch (e) {
      print("Something wrong happened!");
    }
  }

  Future<void> dispose() async {
    await _ethClient.dispose();
    await listenEvent().cancel();
  }
}
