// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package contract

import (
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = abi.U256
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// ContractABI is the input ABI used to generate the binding from.
const ContractABI = "[{\"constant\":false,\"inputs\":[{\"name\":\"refundTime\",\"type\":\"uint256\"},{\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"name\":\"initiator\",\"type\":\"address\"}],\"name\":\"participate\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"secretHash\",\"type\":\"bytes32\"}],\"name\":\"refund\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"refundTime\",\"type\":\"uint256\"},{\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"name\":\"participant\",\"type\":\"address\"}],\"name\":\"initiate\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"secret\",\"type\":\"bytes32\"},{\"name\":\"secretHash\",\"type\":\"bytes32\"}],\"name\":\"redeem\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"bytes32\"}],\"name\":\"swaps\",\"outputs\":[{\"name\":\"initTimestamp\",\"type\":\"uint256\"},{\"name\":\"refundTime\",\"type\":\"uint256\"},{\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"name\":\"secret\",\"type\":\"bytes32\"},{\"name\":\"initiator\",\"type\":\"address\"},{\"name\":\"participant\",\"type\":\"address\"},{\"name\":\"value\",\"type\":\"uint256\"},{\"name\":\"kind\",\"type\":\"uint8\"},{\"name\":\"state\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"refundTime\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"refunder\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Refunded\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"redeemTime\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"secret\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"redeemer\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Redeemed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"initTimestamp\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"refundTime\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"initiator\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"participant\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Participated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"initTimestamp\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"refundTime\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"secretHash\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"initiator\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"participant\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Initiated\",\"type\":\"event\"}]"

// ContractBin is the compiled bytecode used for deploying new contracts.
const ContractBin = `608060405234801561001057600080fd5b50610f13806100206000396000f3fe60806040526004361061004a5760003560e01c80631aa028531461004f5780637249fbb6146100a7578063ae052147146100e2578063b31597ad1461013a578063eb84e7f21461017f575b600080fd5b6100a56004803603606081101561006557600080fd5b810190808035906020019092919080359060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061027a565b005b3480156100b357600080fd5b506100e0600480360360208110156100ca57600080fd5b8101908080359060200190929190505050610517565b005b610138600480360360608110156100f857600080fd5b810190808035906020019092919080359060200190929190803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506107fc565b005b34801561014657600080fd5b5061017d6004803603604081101561015d57600080fd5b810190808035906020019092919080359060200190929190505050610a99565b005b34801561018b57600080fd5b506101b8600480360360208110156101a257600080fd5b8101908080359060200190929190505050610e3f565b604051808a81526020018981526020018881526020018781526020018673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200184815260200183600181111561024a57fe5b60ff16815260200182600381111561025e57fe5b60ff168152602001995050505050505050505060405180910390f35b826000341161028857600080fd5b6000811161029557600080fd5b82600060038111156102a357fe5b60008083815260200190815260200160002060070160019054906101000a900460ff1660038111156102d157fe5b146102db57600080fd5b4260008086815260200190815260200160002060000181905550846000808681526020019081526020016000206001018190555083600080868152602001908152602001600020600201819055508260008086815260200190815260200160002060040160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055503360008086815260200190815260200160002060050160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055503460008086815260200190815260200160002060060181905550600160008086815260200190815260200160002060070160006101000a81548160ff0219169083600181111561041d57fe5b0217905550600160008086815260200190815260200160002060070160016101000a81548160ff0219169083600381111561045457fe5b02179055507fe5571d467a528d7481c0e3bdd55ad528d0df6b457b07bab736c3e245c3aa16f4428686863334604051808781526020018681526020018581526020018473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001828152602001965050505050505060405180910390a15050505050565b80336001600381111561052657fe5b60008084815260200190815260200160002060070160019054906101000a900460ff16600381111561055457fe5b1461055e57600080fd5b60018081111561056a57fe5b60008084815260200190815260200160002060070160009054906101000a900460ff16600181111561059857fe5b1415610610578073ffffffffffffffffffffffffffffffffffffffff1660008084815260200190815260200160002060050160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161461060b57600080fd5b61067e565b8073ffffffffffffffffffffffffffffffffffffffff1660008084815260200190815260200160002060040160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161461067d57600080fd5b5b600080600084815260200190815260200160002060000154905060008084815260200190815260200160002060010154810190508042116106be57600080fd5b3373ffffffffffffffffffffffffffffffffffffffff166108fc600080878152602001908152602001600020600601549081150290604051600060405180830381858888f19350505050158015610719573d6000803e3d6000fd5b50600360008086815260200190815260200160002060070160016101000a81548160ff0219169083600381111561074c57fe5b02179055507fadb1dca52dfad065e50a1e25c2ee47ae54013a1f2d6f8ea5abace52eb4b7a4c842600080878152602001908152602001600020600201543360008089815260200190815260200160002060060154604051808581526020018481526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200182815260200194505050505060405180910390a150505050565b826000341161080a57600080fd5b6000811161081757600080fd5b826000600381111561082557fe5b60008083815260200190815260200160002060070160019054906101000a900460ff16600381111561085357fe5b1461085d57600080fd5b4260008086815260200190815260200160002060000181905550846000808681526020019081526020016000206001018190555083600080868152602001908152602001600020600201819055503360008086815260200190815260200160002060040160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508260008086815260200190815260200160002060050160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055503460008086815260200190815260200160002060060181905550600080600086815260200190815260200160002060070160006101000a81548160ff0219169083600181111561099f57fe5b0217905550600160008086815260200190815260200160002060070160016101000a81548160ff021916908360038111156109d657fe5b02179055507f75501a491c11746724d18ea6e5ac6a53864d886d653da6b846fdecda837cf576428686338734604051808781526020018681526020018581526020018473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001828152602001965050505050505060405180910390a15050505050565b80823360016003811115610aa957fe5b60008085815260200190815260200160002060070160019054906101000a900460ff166003811115610ad757fe5b14610ae157600080fd5b600180811115610aed57fe5b60008085815260200190815260200160002060070160009054906101000a900460ff166001811115610b1b57fe5b1415610b93578073ffffffffffffffffffffffffffffffffffffffff1660008085815260200190815260200160002060040160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614610b8e57600080fd5b610c01565b8073ffffffffffffffffffffffffffffffffffffffff1660008085815260200190815260200160002060050160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614610c0057600080fd5b5b82600283604051602001808281526020019150506040516020818303038152906040526040518082805190602001908083835b60208310610c575780518252602082019150602081019050602083039250610c34565b6001836020036101000a038019825116818451168082178552505050505050905001915050602060405180830381855afa158015610c99573d6000803e3d6000fd5b5050506040513d6020811015610cae57600080fd5b810190808051906020019092919050505014610cc957600080fd5b3373ffffffffffffffffffffffffffffffffffffffff166108fc600080878152602001908152602001600020600601549081150290604051600060405180830381858888f19350505050158015610d24573d6000803e3d6000fd5b50600260008086815260200190815260200160002060070160016101000a81548160ff02191690836003811115610d5757fe5b021790555084600080868152602001908152602001600020600301819055507fe4da013d8c42cdfa76ab1d5c08edcdc1503d2da88d7accc854f0e57ebe45c591426000808781526020019081526020016000206002015460008088815260200190815260200160002060030154336000808a815260200190815260200160002060060154604051808681526020018581526020018481526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018281526020019550505050505060405180910390a15050505050565b60006020528060005260406000206000915090508060000154908060010154908060020154908060030154908060040160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060050160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060060154908060070160009054906101000a900460ff16908060070160019054906101000a900460ff1690508956fea165627a7a723058206e8861bb7dc827d39d22b9a2c761caecc9f8f59d4d72df40c885d99fcc9c74360029`

// DeployContract deploys a new Ethereum contract, binding an instance of Contract to it.
func DeployContract(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *Contract, error) {
	parsed, err := abi.JSON(strings.NewReader(ContractABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(ContractBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &Contract{ContractCaller: ContractCaller{contract: contract}, ContractTransactor: ContractTransactor{contract: contract}, ContractFilterer: ContractFilterer{contract: contract}}, nil
}

// Contract is an auto generated Go binding around an Ethereum contract.
type Contract struct {
	ContractCaller     // Read-only binding to the contract
	ContractTransactor // Write-only binding to the contract
	ContractFilterer   // Log filterer for contract events
}

// ContractCaller is an auto generated read-only Go binding around an Ethereum contract.
type ContractCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ContractTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ContractTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ContractFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ContractFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ContractSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ContractSession struct {
	Contract     *Contract         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ContractCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ContractCallerSession struct {
	Contract *ContractCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// ContractTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ContractTransactorSession struct {
	Contract     *ContractTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// ContractRaw is an auto generated low-level Go binding around an Ethereum contract.
type ContractRaw struct {
	Contract *Contract // Generic contract binding to access the raw methods on
}

// ContractCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ContractCallerRaw struct {
	Contract *ContractCaller // Generic read-only contract binding to access the raw methods on
}

// ContractTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ContractTransactorRaw struct {
	Contract *ContractTransactor // Generic write-only contract binding to access the raw methods on
}

// NewContract creates a new instance of Contract, bound to a specific deployed contract.
func NewContract(address common.Address, backend bind.ContractBackend) (*Contract, error) {
	contract, err := bindContract(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Contract{ContractCaller: ContractCaller{contract: contract}, ContractTransactor: ContractTransactor{contract: contract}, ContractFilterer: ContractFilterer{contract: contract}}, nil
}

// NewContractCaller creates a new read-only instance of Contract, bound to a specific deployed contract.
func NewContractCaller(address common.Address, caller bind.ContractCaller) (*ContractCaller, error) {
	contract, err := bindContract(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ContractCaller{contract: contract}, nil
}

// NewContractTransactor creates a new write-only instance of Contract, bound to a specific deployed contract.
func NewContractTransactor(address common.Address, transactor bind.ContractTransactor) (*ContractTransactor, error) {
	contract, err := bindContract(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ContractTransactor{contract: contract}, nil
}

// NewContractFilterer creates a new log filterer instance of Contract, bound to a specific deployed contract.
func NewContractFilterer(address common.Address, filterer bind.ContractFilterer) (*ContractFilterer, error) {
	contract, err := bindContract(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ContractFilterer{contract: contract}, nil
}

// bindContract binds a generic wrapper to an already deployed contract.
func bindContract(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ContractABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Contract *ContractRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _Contract.Contract.ContractCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Contract *ContractRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Contract.Contract.ContractTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Contract *ContractRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Contract.Contract.ContractTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Contract *ContractCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _Contract.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Contract *ContractTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Contract.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Contract *ContractTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Contract.Contract.contract.Transact(opts, method, params...)
}

// Swaps is a free data retrieval call binding the contract method 0xeb84e7f2.
//
// Solidity: function swaps(bytes32 ) constant returns(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, bytes32 secret, address initiator, address participant, uint256 value, uint8 kind, uint8 state)
func (_Contract *ContractCaller) Swaps(opts *bind.CallOpts, arg0 [32]byte) (struct {
	InitTimestamp *big.Int
	RefundTime    *big.Int
	SecretHash    [32]byte
	Secret        [32]byte
	Initiator     common.Address
	Participant   common.Address
	Value         *big.Int
	Kind          uint8
	State         uint8
}, error) {
	ret := new(struct {
		InitTimestamp *big.Int
		RefundTime    *big.Int
		SecretHash    [32]byte
		Secret        [32]byte
		Initiator     common.Address
		Participant   common.Address
		Value         *big.Int
		Kind          uint8
		State         uint8
	})
	out := ret
	err := _Contract.contract.Call(opts, out, "swaps", arg0)
	return *ret, err
}

// Swaps is a free data retrieval call binding the contract method 0xeb84e7f2.
//
// Solidity: function swaps(bytes32 ) constant returns(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, bytes32 secret, address initiator, address participant, uint256 value, uint8 kind, uint8 state)
func (_Contract *ContractSession) Swaps(arg0 [32]byte) (struct {
	InitTimestamp *big.Int
	RefundTime    *big.Int
	SecretHash    [32]byte
	Secret        [32]byte
	Initiator     common.Address
	Participant   common.Address
	Value         *big.Int
	Kind          uint8
	State         uint8
}, error) {
	return _Contract.Contract.Swaps(&_Contract.CallOpts, arg0)
}

// Swaps is a free data retrieval call binding the contract method 0xeb84e7f2.
//
// Solidity: function swaps(bytes32 ) constant returns(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, bytes32 secret, address initiator, address participant, uint256 value, uint8 kind, uint8 state)
func (_Contract *ContractCallerSession) Swaps(arg0 [32]byte) (struct {
	InitTimestamp *big.Int
	RefundTime    *big.Int
	SecretHash    [32]byte
	Secret        [32]byte
	Initiator     common.Address
	Participant   common.Address
	Value         *big.Int
	Kind          uint8
	State         uint8
}, error) {
	return _Contract.Contract.Swaps(&_Contract.CallOpts, arg0)
}

// Initiate is a paid mutator transaction binding the contract method 0xae052147.
//
// Solidity: function initiate(uint256 refundTime, bytes32 secretHash, address participant) returns()
func (_Contract *ContractTransactor) Initiate(opts *bind.TransactOpts, refundTime *big.Int, secretHash [32]byte, participant common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "initiate", refundTime, secretHash, participant)
}

// Initiate is a paid mutator transaction binding the contract method 0xae052147.
//
// Solidity: function initiate(uint256 refundTime, bytes32 secretHash, address participant) returns()
func (_Contract *ContractSession) Initiate(refundTime *big.Int, secretHash [32]byte, participant common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Initiate(&_Contract.TransactOpts, refundTime, secretHash, participant)
}

// Initiate is a paid mutator transaction binding the contract method 0xae052147.
//
// Solidity: function initiate(uint256 refundTime, bytes32 secretHash, address participant) returns()
func (_Contract *ContractTransactorSession) Initiate(refundTime *big.Int, secretHash [32]byte, participant common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Initiate(&_Contract.TransactOpts, refundTime, secretHash, participant)
}

// Participate is a paid mutator transaction binding the contract method 0x1aa02853.
//
// Solidity: function participate(uint256 refundTime, bytes32 secretHash, address initiator) returns()
func (_Contract *ContractTransactor) Participate(opts *bind.TransactOpts, refundTime *big.Int, secretHash [32]byte, initiator common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "participate", refundTime, secretHash, initiator)
}

// Participate is a paid mutator transaction binding the contract method 0x1aa02853.
//
// Solidity: function participate(uint256 refundTime, bytes32 secretHash, address initiator) returns()
func (_Contract *ContractSession) Participate(refundTime *big.Int, secretHash [32]byte, initiator common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Participate(&_Contract.TransactOpts, refundTime, secretHash, initiator)
}

// Participate is a paid mutator transaction binding the contract method 0x1aa02853.
//
// Solidity: function participate(uint256 refundTime, bytes32 secretHash, address initiator) returns()
func (_Contract *ContractTransactorSession) Participate(refundTime *big.Int, secretHash [32]byte, initiator common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Participate(&_Contract.TransactOpts, refundTime, secretHash, initiator)
}

// Redeem is a paid mutator transaction binding the contract method 0xb31597ad.
//
// Solidity: function redeem(bytes32 secret, bytes32 secretHash) returns()
func (_Contract *ContractTransactor) Redeem(opts *bind.TransactOpts, secret [32]byte, secretHash [32]byte) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "redeem", secret, secretHash)
}

// Redeem is a paid mutator transaction binding the contract method 0xb31597ad.
//
// Solidity: function redeem(bytes32 secret, bytes32 secretHash) returns()
func (_Contract *ContractSession) Redeem(secret [32]byte, secretHash [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.Redeem(&_Contract.TransactOpts, secret, secretHash)
}

// Redeem is a paid mutator transaction binding the contract method 0xb31597ad.
//
// Solidity: function redeem(bytes32 secret, bytes32 secretHash) returns()
func (_Contract *ContractTransactorSession) Redeem(secret [32]byte, secretHash [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.Redeem(&_Contract.TransactOpts, secret, secretHash)
}

// Refund is a paid mutator transaction binding the contract method 0x7249fbb6.
//
// Solidity: function refund(bytes32 secretHash) returns()
func (_Contract *ContractTransactor) Refund(opts *bind.TransactOpts, secretHash [32]byte) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "refund", secretHash)
}

// Refund is a paid mutator transaction binding the contract method 0x7249fbb6.
//
// Solidity: function refund(bytes32 secretHash) returns()
func (_Contract *ContractSession) Refund(secretHash [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.Refund(&_Contract.TransactOpts, secretHash)
}

// Refund is a paid mutator transaction binding the contract method 0x7249fbb6.
//
// Solidity: function refund(bytes32 secretHash) returns()
func (_Contract *ContractTransactorSession) Refund(secretHash [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.Refund(&_Contract.TransactOpts, secretHash)
}

// ContractInitiatedIterator is returned from FilterInitiated and is used to iterate over the raw logs and unpacked data for Initiated events raised by the Contract contract.
type ContractInitiatedIterator struct {
	Event *ContractInitiated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractInitiatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractInitiated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractInitiated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractInitiatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractInitiatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractInitiated represents a Initiated event raised by the Contract contract.
type ContractInitiated struct {
	InitTimestamp *big.Int
	RefundTime    *big.Int
	SecretHash    [32]byte
	Initiator     common.Address
	Participant   common.Address
	Value         *big.Int
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterInitiated is a free log retrieval operation binding the contract event 0x75501a491c11746724d18ea6e5ac6a53864d886d653da6b846fdecda837cf576.
//
// Solidity: event Initiated(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, address initiator, address participant, uint256 value)
func (_Contract *ContractFilterer) FilterInitiated(opts *bind.FilterOpts) (*ContractInitiatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Initiated")
	if err != nil {
		return nil, err
	}
	return &ContractInitiatedIterator{contract: _Contract.contract, event: "Initiated", logs: logs, sub: sub}, nil
}

// WatchInitiated is a free log subscription operation binding the contract event 0x75501a491c11746724d18ea6e5ac6a53864d886d653da6b846fdecda837cf576.
//
// Solidity: event Initiated(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, address initiator, address participant, uint256 value)
func (_Contract *ContractFilterer) WatchInitiated(opts *bind.WatchOpts, sink chan<- *ContractInitiated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Initiated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractInitiated)
				if err := _Contract.contract.UnpackLog(event, "Initiated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ContractParticipatedIterator is returned from FilterParticipated and is used to iterate over the raw logs and unpacked data for Participated events raised by the Contract contract.
type ContractParticipatedIterator struct {
	Event *ContractParticipated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractParticipatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractParticipated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractParticipated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractParticipatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractParticipatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractParticipated represents a Participated event raised by the Contract contract.
type ContractParticipated struct {
	InitTimestamp *big.Int
	RefundTime    *big.Int
	SecretHash    [32]byte
	Initiator     common.Address
	Participant   common.Address
	Value         *big.Int
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterParticipated is a free log retrieval operation binding the contract event 0xe5571d467a528d7481c0e3bdd55ad528d0df6b457b07bab736c3e245c3aa16f4.
//
// Solidity: event Participated(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, address initiator, address participant, uint256 value)
func (_Contract *ContractFilterer) FilterParticipated(opts *bind.FilterOpts) (*ContractParticipatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Participated")
	if err != nil {
		return nil, err
	}
	return &ContractParticipatedIterator{contract: _Contract.contract, event: "Participated", logs: logs, sub: sub}, nil
}

// WatchParticipated is a free log subscription operation binding the contract event 0xe5571d467a528d7481c0e3bdd55ad528d0df6b457b07bab736c3e245c3aa16f4.
//
// Solidity: event Participated(uint256 initTimestamp, uint256 refundTime, bytes32 secretHash, address initiator, address participant, uint256 value)
func (_Contract *ContractFilterer) WatchParticipated(opts *bind.WatchOpts, sink chan<- *ContractParticipated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Participated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractParticipated)
				if err := _Contract.contract.UnpackLog(event, "Participated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ContractRedeemedIterator is returned from FilterRedeemed and is used to iterate over the raw logs and unpacked data for Redeemed events raised by the Contract contract.
type ContractRedeemedIterator struct {
	Event *ContractRedeemed // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRedeemedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRedeemed)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRedeemed)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRedeemedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRedeemedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRedeemed represents a Redeemed event raised by the Contract contract.
type ContractRedeemed struct {
	RedeemTime *big.Int
	SecretHash [32]byte
	Secret     [32]byte
	Redeemer   common.Address
	Value      *big.Int
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterRedeemed is a free log retrieval operation binding the contract event 0xe4da013d8c42cdfa76ab1d5c08edcdc1503d2da88d7accc854f0e57ebe45c591.
//
// Solidity: event Redeemed(uint256 redeemTime, bytes32 secretHash, bytes32 secret, address redeemer, uint256 value)
func (_Contract *ContractFilterer) FilterRedeemed(opts *bind.FilterOpts) (*ContractRedeemedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Redeemed")
	if err != nil {
		return nil, err
	}
	return &ContractRedeemedIterator{contract: _Contract.contract, event: "Redeemed", logs: logs, sub: sub}, nil
}

// WatchRedeemed is a free log subscription operation binding the contract event 0xe4da013d8c42cdfa76ab1d5c08edcdc1503d2da88d7accc854f0e57ebe45c591.
//
// Solidity: event Redeemed(uint256 redeemTime, bytes32 secretHash, bytes32 secret, address redeemer, uint256 value)
func (_Contract *ContractFilterer) WatchRedeemed(opts *bind.WatchOpts, sink chan<- *ContractRedeemed) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Redeemed")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRedeemed)
				if err := _Contract.contract.UnpackLog(event, "Redeemed", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ContractRefundedIterator is returned from FilterRefunded and is used to iterate over the raw logs and unpacked data for Refunded events raised by the Contract contract.
type ContractRefundedIterator struct {
	Event *ContractRefunded // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRefundedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRefunded)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRefunded)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRefundedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRefundedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRefunded represents a Refunded event raised by the Contract contract.
type ContractRefunded struct {
	RefundTime *big.Int
	SecretHash [32]byte
	Refunder   common.Address
	Value      *big.Int
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterRefunded is a free log retrieval operation binding the contract event 0xadb1dca52dfad065e50a1e25c2ee47ae54013a1f2d6f8ea5abace52eb4b7a4c8.
//
// Solidity: event Refunded(uint256 refundTime, bytes32 secretHash, address refunder, uint256 value)
func (_Contract *ContractFilterer) FilterRefunded(opts *bind.FilterOpts) (*ContractRefundedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Refunded")
	if err != nil {
		return nil, err
	}
	return &ContractRefundedIterator{contract: _Contract.contract, event: "Refunded", logs: logs, sub: sub}, nil
}

// WatchRefunded is a free log subscription operation binding the contract event 0xadb1dca52dfad065e50a1e25c2ee47ae54013a1f2d6f8ea5abace52eb4b7a4c8.
//
// Solidity: event Refunded(uint256 refundTime, bytes32 secretHash, address refunder, uint256 value)
func (_Contract *ContractFilterer) WatchRefunded(opts *bind.WatchOpts, sink chan<- *ContractRefunded) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Refunded")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRefunded)
				if err := _Contract.contract.UnpackLog(event, "Refunded", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}
