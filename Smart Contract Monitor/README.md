
# Smart Contract Monitor

### Prerequisites
1. Moralis API key - (https://admin.moralis.io/web3apis)
2. Code editor such as Visual Studio Code - (https://code.visualstudio.com/download)
3. NodeJS - (https://nodejs.org/en/download/)
4. Smart contract with read only functions - (https://bscscan.com/contractsVerified)

### Steps

1. Create project directory
	- mkdir *directoryName*
2. Initialize project and install dependancies
	- *npm init -y*
	- *npm i moralis dotenv*
1. Create neccessary files
	- *touch .env*
	- *touch index.js*
	- *touch abi.json*
4. Populate files with neccesarry data
	- .env : API KEY
	- abi.json : contract ABI
5. Ensure the following within the *index.js* file are changed/ammended as per your usecase
	- chain - refers to the network you are connecting to (https://docs.moralis.io/web3-data-api/reference/run-contract-function)
	- address - refers to the smart contract address
	- functionName - the name of the function you are calling from your smart contract
6. Run application
	- *node index.js*
