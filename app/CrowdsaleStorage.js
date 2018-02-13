// Import libraries we need
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them to usable abstraction
import CrowdsaleStorageArtifacts from '../build/contracts/CrowdsaleStorage.json';

// Creates usable abstractions
const CrowdsaleStorage = contract(CrowdsaleStorageArtifacts);

let account;    // Stores user account between calls

window.App = {
    // Initializing function
    start: function () {
        CrowdsaleStorage.setProvider(web3.currentProvider);

        // Get the initial account balance so it can be displayed.
        web3.eth.getAccounts(function(err, accs) {
            if (err !== null) {
                alert('Log in your MetaMask account')
                return
            }

            if (accs.length === 0) {
                alert('Cannot get accounts from MetaMask')
                return
            }
            account = accs[0]
        })
    },
     addCrowdsale: function (_crowdsaleAddress, _tokenAddress) {
        CrowdsaleStorage.deployed().then(function (instance) {
            instance.addCrowdsale(_crowdsaleAddress, _tokenAddress,{from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    setCrowdsaleToken: function (_crowdsaleId, _tokenAddress) {
        CrowdsaleStorage.deployed().then(function (instance) {
            instance.setCrowdsaleToken(_crowdsaleId, _tokenAddress, {from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    setCrowdsaleEnded: function (_crowdsaleId) {
        CrowdsaleStorage.deployed().then(function (instance) {
            instance.setCrowdsaleEnded(_crowdsaleId, {from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    setCrowdsaleActive: function (_crowdsaleId) {
        CrowdsaleStorage.deployed().then(function (instance) {
            instance.setCrowdsaleActive(_crowdsaleId, {from: account})
        }).catch(function (e) {
            console.log(e)
        })
    }
};

window.addEventListener('load', function () {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        window.web3 = new Web3(web3.currentProvider)
    } else {
        alert('You should download MetaMask/Mist for security reasons')
    }

    App.start()
});
