package co.topl.bridge

import co.topl.shared.BitcoinNetworkIdentifiers
import scopt.OParser

trait BridgeParamsDescriptor {

  import co.topl.shared.ParamParser._

  val builder = OParser.builder[ToplBTCBridgeParamConfig]

  val parser = {
    import builder._

    OParser.sequence(
      programName("topl-btc-bridge"),
      head("topl-btc-bridge", "0.1"),
      opt[BitcoinNetworkIdentifiers]('n', "network")
        .action((x, c) => c.copy(btcNetwork = x))
        .text(
          "Network name: Possible values: mainnet, testnet, regtest. (mandatory)"
        ),
      opt[Int]("blocks-to-recover")
        .action((x, c) => c.copy(blockToRecover = x))
        .text(
          "The number of blocks that the user needs to wait before they can reclaim their funds. (default: 100)"
        ),
      opt[String]("peg-in-seed-file")
        .action((x, c) => c.copy(pegInSeedFile = x))
        .text(
          "The path to the peg inn seed file. (default: pegin-wallet.json)"
        ),
      opt[String]("peg-in-password")
        .action((x, c) => c.copy(pegInPassword = x))
        .text(
          "The password to the seed file. (default: password)"
        ),
      opt[String]("seed-file")
        .action((x, c) => c.copy(walletSeedFile = x))
        .text(
          "The path to the seed file. (default: wallet.json)"
        ),
      opt[String]("password")
        .action((x, c) => c.copy(walletPassword = x))
        .text(
          "The password to the seed file. (default: password)"
        ),
    )
  }

}
