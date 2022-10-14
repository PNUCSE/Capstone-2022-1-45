var express = require('express');
var bodyParser = require('body-parser');
const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');

var app = express();
app.use(bodyParser.json());

const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');
const ccpPath = path.resolve(__dirname, '..', '..', 'pnu-network', 'organizations', 'peerOrganizations', 'rec-client-peer-org.pnu.com', 'connection-rec-client-peer-org.json');
function printSystemLog(functionName) { console.info('========= ' + functionName + ' =========') }

/**
 * 인증서 등록
 * 
 * @param {String: 구매자 ID} supplier
 * @param {Int: 판매 수량} quantity 
 * @param {Bool: 제주도 발전 여부} is_jeju
 * @param {Int: 공급 날짜} supply_date
 * @param {Int: 만료 날짜} expire_date
 */
 app.post('/certificate/register/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get(`${req.body.supplier}`);
        if (!identity) {
            res.status(401).json({error: `An identity for the user ${req.body.supplier} does not exist in the wallet`});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: `${req.body.supplier}`, discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        await contract.submitTransaction('registerCertificate', 
            req.body.supplier,
            req.body.quantity,
            req.body.is_jeju,
            req.body.supply_date,
            req.body.expire_date
        )

        res.status(200).json({response: "Successfully added certificate"});
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 해당 유저의 등록된 인증서를 조회하는 API
 * 
 */
 app.get('/certificate/query/:supplierId', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'Run the registerUser.js application before retrying'});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryCertificates', req.params.supplierId);

        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 해당 공급자의 등록된 인증서 합을 조회하는 API
 * 
 */
 app.get('/certificate/query-sum-by-supplier/:supplierId', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'Run the registerUser.js application before retrying'});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryCertificateSumBySupplier', req.params.supplierId);

        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 해당 구매자의 구매한 인증서 합을 조회하는 API
 * 
 */
 app.get('/certificate/query-sum-by-buyer/:buyerId', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'Run the registerUser.js application before retrying'});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryCertificateSumByBuyer', req.params.buyerId);

        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * REC 판매 등록 API
 * 
 * @method  POST
 * 
 * @param target    REC ID 값
 * @param price     REC 개당 가격
 * @param quantity  REC 개수
 * @param supplier  REC 공급자
 */
 app.post('/transaction/create/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get(`${req.body.supplier}`);
        if (!identity) {
            res.status(401).json({error: `An identity for the user "${req.body.supplier}" does not exist in the wallet`});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: `${req.body.supplier}`, discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        await contract.submitTransaction('createNewTransaction', 
            req.body.target,
            req.body.price,
            req.body.quantity,
            req.body.supplier,
        )

        res.status(200).json({response: "Successfully created transaction"});
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * REC 매수 API
 * 
 * @method  POST
 * 
 * @param id        Transaction ID
 * @param buyer     구매자 ID
 */
 app.post('/transaction/execute/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get(`${req.body.buyer}`);
        if (!identity) {
            res.status(401).json({error: `An identity for the user "${req.body.buyer}" does not exist in the wallet`});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: `${req.body.buyer}`, discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        await contract.submitTransaction('executeTransaction', 
            req.body.id,
            req.body.buyer
        )

        res.status(200).json({response: "Successfully executed transaction"});
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 거래 승인 API
 * 
 * @method  POST
 * 
 * @param id        Transaction ID
 */
 app.post('/transaction/approve/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: `An identity for the user "appUser" does not exist in the wallet`});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        await contract.submitTransaction('approveTransaction', 
            req.body.id,
        )

        res.status(200).json({response: "Successfully executed transaction"});
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});


/**
 * REC 거래 ID 값을 기반으로 조회하는 API
 */
app.get('/transaction/query/:transactionId', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryTransactionById', req.params.transactionId);
        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 모든 거래 내역을 조회하는 API
 */
 app.get('/transaction/query-all/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'Run the registerUser.js application before retrying'});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryAllTransactions');

        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 미체결된 거래 내역을 조회하는 API
 */
 app.get('/transaction/query-nonexecuted/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryUnexecutedTransactions');
        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 체결된 거래 내역을 조회하는 API
 */
 app.get('/transaction/query-executed/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.evaluateTransaction('queryExecutedTransactions');
        res.status(200).json(JSON.parse(result.toString()));
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 공급자 ID로 거래 내역 조회
 */
app.post('/transaction/query-by-supplier/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.submitTransaction('queryTransactionBySupplier', 
            req.body.supplier,
        )

        res.status(200).json(JSON.parse(result.toString()));
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 구매자 ID로 거래 내역 조회
 */
app.post('/transaction/query-by-buyer/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }
        
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.submitTransaction('queryTransactionByBuyer', 
            req.body.buyer,
        )

        res.status(200).json(JSON.parse(result.toString()));
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 구매자 ID로 승인되지 않은 거래 내역 조회
 */
 app.post('/transaction/query-non-confirmed-by-buyer/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }
        
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.submitTransaction('queryNonConfirmedByBuyer', 
            req.body.buyer,
        )

        res.status(200).json(JSON.parse(result.toString()));
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 판매자 ID로 승인되지 않은 거래 내역 조회
 */
 app.post('/transaction/query-non-confirmed-by-supplier/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }
        
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        const result = await contract.submitTransaction('queryNonConfirmedBySupplier', 
            req.body.supplier,
        )

        res.status(200).json(JSON.parse(result.toString()));
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});

/**
 * 사용자 등록 API
 * 
 * @param departmentName    buyer 또는 supplier   
 * @param enrollmentID      등록할 사용자 ID
 */
app.post('/register/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get(`${req.body.enrollmentID}`);
        if (identity) {
            res.status(406).json({error: `"${req.body.enrollmentID}" already exist in the wallet`});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const caURL = ccp.certificateAuthorities['ca.rec-client-peer-org.pnu.com'].url;
        const ca = new FabricCAServices(caURL);

        const adminIdentity = await wallet.get('admin');
        if (!adminIdentity) {
            res.status(400).json({error: 'An identity for the admin user "admin" does not exist in the wallet'});
        }

        const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
        const adminUser = await provider.getUserContext(adminIdentity, 'admin');

        const secret = await ca.register({
            affiliation: `rec-client-peer-org.${req.body.departmentName}`,
            enrollmentID: `${req.body.enrollmentID}`,
            role: 'client'
        }, adminUser);

        const enrollment = await ca.enroll({
            enrollmentID: `${req.body.enrollmentID}`,
            enrollmentSecret: secret
        });

        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'RecClientPeerOrgMSP',
            type: 'X.509',
        };

        await wallet.put(`${req.body.enrollmentID}`, x509Identity);
        res.status(200).json({response: `Successfully register "${req.body.enrollmentID}" and imported it into the wallet`});

    } catch (error) {
        res.status(500).json({error: error});
    }
});

app.get('/addExamples/:amount', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get('appUser');
        if (!identity) {
            res.status(401).json({error: 'An identity for the user "appUser" does not exist in the wallet'});
        }

        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        await contract.submitTransaction('addExamples', 
            req.params.amount
        )
        res.status(200).json({response: `Successfully added examples`});
        await gateway.disconnect();
    } catch (error) {
        res.status(500).json({error: error});
    }
});


    /**
     * 샘플 인증서 판매 등록
     * 
     * @param {인증서 ID} target 
     * @param {인증서 개당 가격} price 
     * @param {인증서 판매 수량} quantity 
     * @param {공급자 ID} supplier  
     * @param {구매자 ID} buyer  
     * @param {등록 날짜} registeredDate
     * @param {구매 날짜} executedDate
     * @param {승인 여부} is_confirmed 
     */
 app.post('/transaction/createExample/', async function (req, res) {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(`CCP path: ${ccpPath}`);

        const identity = await wallet.get(`${req.body.supplier}`);
        if (!identity) {
            res.status(401).json({error: `An identity for the user "${req.body.supplier}" does not exist in the wallet`});
        }
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));        
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: `${req.body.supplier}`, discovery: { enabled: true, asLocalhost: true } });

        const network = await gateway.getNetwork('rec-trade-channel');
        const contract = network.getContract('pnucc');

        await contract.submitTransaction('createExampleTransaction', 
            req.body.target,
            req.body.price,
            req.body.quantity,
            req.body.supplier,
            req.body.buyer,
            req.body.registeredDate,
            req.body.executedDate,
            req.body.is_confirmed,
        )

        res.status(200).json({response: "Successfully created transaction"});
        await gateway.disconnect();
        
    } catch (error) {
        res.status(500).json({error: error});
    }
});


app.listen(8080);