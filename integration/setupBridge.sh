#!/bin/bash

shopt -s expand_aliases
alias plasma-cli="cs launch -r https://s01.oss.sonatype.org/content/repositories/releases org.plasmalabs:plasma-cli_2.13:0.1.2 -- "
export BTC_USER=bitcoin
export BTC_PASSWORD=password
export PLASMA_WALLET_DB=plasma-wallet.db
export PLASMA_WALLET_JSON=plasma-wallet.json
export PLASMA_WALLET_MNEMONIC=plasma-mnemonic.txt
export PLASMA_WALLET_PASSWORD=password
rm -rf $PLASMA_WALLET_DB $PLASMA_WALLET_JSON $PLASMA_WALLET_MNEMONIC 
plasma-cli node-query mint-block --nb-blocks 1 -h 127.0.0.1  --port 9084 -s false
rm genesisTx.pbuf genesisTxProved.pbuf groupMintingtx.pbuf groupMintingtxProved.pbuf seriesMintingTx.pbuf seriesMintingTxProved.pbuf
plasma-cli wallet init --network private --password password --newwalletdb $PLASMA_WALLET_DB --mnemonicfile $PLASMA_WALLET_MNEMONIC --output $PLASMA_WALLET_JSON
export ADDRESS=$(plasma-cli wallet current-address --walletdb $PLASMA_WALLET_DB)
plasma-cli simple-transaction create --from-fellowship nofellowship --from-template genesis --from-interaction 1 --change-fellowship nofellowship --change-template genesis --change-interaction 1  -t $ADDRESS -w $PLASMA_WALLET_PASSWORD -o genesisTx.pbuf -n private -a 1000 -h  127.0.0.1 --port 9084 --keyfile $PLASMA_WALLET_JSON --walletdb $PLASMA_WALLET_DB --fee 10 --transfer-token lvl
plasma-cli tx prove -i genesisTx.pbuf --walletdb $PLASMA_WALLET_DB --keyfile $PLASMA_WALLET_JSON -w $PLASMA_WALLET_PASSWORD -o genesisTxProved.pbuf
export GROUP_UTXO=$(plasma-cli tx broadcast -i genesisTxProved.pbuf -h 127.0.0.1 --port 9084)
plasma-cli node-query mint-block --nb-blocks 1 -h 127.0.0.1  --port 9084 -s false
until plasma-cli indexer-query utxo-by-address --host localhost --port 9084 --secure false --walletdb $PLASMA_WALLET_DB; do sleep 5; done
echo "label: PlasmaBTCGroup" > groupPolicy.yaml
echo "registrationUtxo: $GROUP_UTXO#0" >> groupPolicy.yaml
plasma-cli simple-minting create --from-fellowship self --from-template default  -h 127.0.0.1 --port 9084 -n private --keyfile $PLASMA_WALLET_JSON -w $PLASMA_WALLET_PASSWORD -o groupMintingtx.pbuf -i groupPolicy.yaml  --mint-amount 1 --fee 10 --walletdb $PLASMA_WALLET_DB --mint-token group
plasma-cli tx prove -i groupMintingtx.pbuf --walletdb $PLASMA_WALLET_DB --keyfile $PLASMA_WALLET_JSON -w $PLASMA_WALLET_PASSWORD -o groupMintingtxProved.pbuf
export SERIES_UTXO=$(plasma-cli tx broadcast -i groupMintingtxProved.pbuf -h 127.0.0.1 --port 9084)
plasma-cli node-query mint-block --nb-blocks 1 -h 127.0.0.1  --port 9084 -s false
echo "SERIES_UTXO: $SERIES_UTXO"
until plasma-cli indexer-query utxo-by-address --host localhost --port 9084 --secure false --walletdb $PLASMA_WALLET_DB; do sleep 5; done
echo "label: PlasmaBTCSeries" > seriesPolicy.yaml
echo "registrationUtxo: $SERIES_UTXO#0" >> seriesPolicy.yaml
echo "fungibility: group-and-series" >> seriesPolicy.yaml
echo "quantityDescriptor: liquid" >> seriesPolicy.yaml
plasma-cli simple-minting create --from-fellowship self --from-template default  -h localhost --port 9084 -n private --keyfile $PLASMA_WALLET_JSON -w $PLASMA_WALLET_PASSWORD -o seriesMintingTx.pbuf -i seriesPolicy.yaml  --mint-amount 1 --fee 10 --walletdb $PLASMA_WALLET_DB --mint-token series
plasma-cli tx prove -i seriesMintingTx.pbuf --walletdb $PLASMA_WALLET_DB --keyfile $PLASMA_WALLET_JSON -w $PLASMA_WALLET_PASSWORD -o seriesMintingTxProved.pbuf
export ASSET_UTXO=$(plasma-cli tx broadcast -i seriesMintingTxProved.pbuf -h 127.0.0.1 --port 9084)
plasma-cli node-query mint-block --nb-blocks 1 -h 127.0.0.1  --port 9084 -s false
echo "ASSET_UTXO: $ASSET_UTXO"
until plasma-cli indexer-query utxo-by-address --host localhost --port 9084 --secure false --walletdb $PLASMA_WALLET_DB; do sleep 5; done