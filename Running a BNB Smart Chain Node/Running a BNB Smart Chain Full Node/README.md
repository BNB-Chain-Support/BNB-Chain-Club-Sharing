# Running a Full Node on BNB Smart Chain

We will follow the steps in our documentation website - https://docs.bnbchain.org/docs/validator/fullnode.
For this tutorial we will use an Amazon Linux 2 server.


Steps:

1. Create your node directory. We will name ours bsc_node.

```
mkdir bsc_node
cd bsc_node
```


2. Download the pre-build binaries.

```
wget   $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)
mv geth_linux geth
chmod -v u+x geth
```

3. Download the configuration files.

```
wget   $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep mainnet |cut -d\" -f4)
unzip mainnet.zip
```

4. Download latest chaindata snapshot. Edit the snapshot URL as needed.

```
nohup aria2c -o geth.tar.lz4 -s14 -x14 -k100M https://pub-c0627345c16f47ab858c9469133073a8.r2.dev/geth-20230304.tar.lz4 -o geth.tar.lz4 &
```

Monitor the download status by checking nohup.out from time to time.

```
tail -40 nohup.out
```

5. Uncompress geth.tar.lz4 snapshot. 

```
nohup tar -I lz4 -xvf geth.tar.lz4 &
```

Monitor the uncompress status by checking nohup.out from time to time.

```
tail -40 nohup.out
```

6. Once you have the uncompressed snaphot, move the chaindata and triecache folders to your node's data directory (where the -datadir flag) will point to. In our case, we created a new folder named node, and we moved the extracted snapshot data inside this folder.

```
mkdir node
cd node
mkdir geth
cd geth
cd ..\..
```

```
mv server/data-seed/geth/chaindata node/geth/chaindata
mv server/data-seed/geth/triecache node/geth/triecache
```


7. Start your node.

```
nohup ./geth --config ./config.toml --datadir ./node  --cache 8000 --rpc.allow-unprotected-txs --txlookuplimit 0 &
```

8. Monitor node syncing status by checking bsc.log entries. 

```
tail -40 node/bsc.log
```

9. Let your node run for a few minutes. You should be able to see "Imported new chain segment" logs.
10. 10. Verifying the node status using the Geth Javascript Console

Run the console.

```
./geth attach ipc:./node/geth.ipc
```

Check the syncing status. Below command returns false if the block is up to date, else it will continue syncing until it is and it will return the last imported block until syncing is completed.

```
eth.syncing
```

