module.exports = {

  networks: {
    development: {
     host: "192.168.1.79",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
  },

  // Configure your compilers
  contracts_directory: './contracts/',
  contracts_build_directory: './assets/contracts_abis/',
  compilers: {
    solc: {
      version: "0.8.3",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: true,
         runs: 200
       },
      //  evmVersion: "byzantium"
      // }
    }
  },

  db: {
    enabled: false
  }
};
