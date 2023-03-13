# Running a Full Node on BNB Smart Chain

We will follow the steps defined here https://docs.bnbchain.org/docs/validator/fullnode.
We are using an Amazon Linux 2 server for this tutorial.

Steps:

1. Download the pre-build binaries.

wget   $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)
mv geth_linux geth
chmod -v u+x geth

2. Download the configuration files.

wget   $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep mainnet |cut -d\" -f4)
unzip mainnet.zip

3. Download latest chaindata snapshot. 

nohup aria2c -o geth.tar.lz4 -s14 -x14 -k100M https://pub-c0627345c16f47ab858c9469133073a8.r2.dev/geth-20230304.tar.lz4 -o geth.tar.lz4 &

Monitor the download status by checking nohup.out from time to time.

tail -40 nohup.out

4. Uncompress geth.tar.lz4 snapshot. 

nohup tar -I lz4 -xvf geth.tar.lz4 &

Monitor the download status by checking nohup.out from time to time.

tail -40 nohup.out


5. Once you have the uncompressed snaphot, move the chaindata and triecache folders to your node's data directory (where the -datadir flag) will point to. In our case, we created a new folder named node, and we moved the extracted snapshot data inside this folder.

mkdir node
cd node
mkdir geth
cd geth

mv server/data-seed/geth/chaindata node/geth/chaindata
mv server/data-seed/geth/triecache node/geth/triecache

6. Start your node.

nohup ./geth --config ./config.toml --datadir ./node  --cache 8000 --rpc.allow-unprotected-txs --txlookuplimit 0 &


7. Monitor node syncing status by checking bsc.log entries. 

tail -40 node/bsc.log

8. 


