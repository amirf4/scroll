// File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol


// OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
 * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() initializer {}
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
        // contract may have been reentered.
        require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

// File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol


// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal onlyInitializing {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal onlyInitializing {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// File: src/L1/rollup/IL1MessageQueue.sol



pragma solidity ^0.8.0;

interface IL1MessageQueue {
  /**********
   * Events *
   **********/

  /// @notice Emitted when a new L1 => L2 transaction is appended to the queue.
  /// @param sender The address of account who initiates the transaction.
  /// @param target The address of account who will recieve the transaction.
  /// @param value The value passed with the transaction.
  /// @param queueIndex The index of this transaction in the queue.
  /// @param gasLimit Gas limit required to complete the message relay on L2.
  /// @param data The calldata of the transaction.
  event QueueTransaction(
    address indexed sender,
    address indexed target,
    uint256 value,
    uint256 queueIndex,
    uint256 gasLimit,
    bytes data
  );

  /*************************
   * Public View Functions *
   *************************/

  /// @notice Return the index of next appended message.
  /// @dev Also the total number of appended messages.
  function nextCrossDomainMessageIndex() external view returns (uint256);

  /// @notice Return the message of in `queueIndex`.
  /// @param queueIndex The index to query.
  function getCrossDomainMessage(uint256 queueIndex) external view returns (bytes32);

  /// @notice Return the amount of ETH should pay for cross domain message.
  /// @param sender The address of account who initiates the message in L1.
  /// @param target The address of account who will recieve the message in L2.
  /// @param message The content of the message.
  /// @param gasLimit Gas limit required to complete the message relay on L2.
  function estimateCrossDomainMessageFee(
    address sender,
    address target,
    bytes memory message,
    uint256 gasLimit
  ) external view returns (uint256);

  /****************************
   * Public Mutated Functions *
   ****************************/

  /// @notice Append a L1 to L2 message into this contract.
  /// @param target The address of target contract to call in L2.
  /// @param gasLimit The maximum gas should be used for relay this message in L2.
  /// @param data The calldata passed to target contract.
  function appendCrossDomainMessage(
    address target,
    uint256 gasLimit,
    bytes calldata data
  ) external;

  /// @notice Append an enforced transaction to this contract.
  /// @dev The address of sender should be an EOA.
  /// @param sender The address of sender who will initiate this transaction in L2.
  /// @param target The address of target contract to call in L2.
  /// @param value The value passed
  /// @param gasLimit The maximum gas should be used for this transaction in L2.
  /// @param data The calldata passed to target contract.
  function appendEnforcedTransaction(
    address sender,
    address target,
    uint256 value,
    uint256 gasLimit,
    bytes calldata data
  ) external;
}

// File: src/L1/rollup/IScrollChain.sol



pragma solidity ^0.8.0;

interface IScrollChain {
  /**********
   * Events *
   **********/

  /// @notice Emitted when a new batch is commited.
  /// @param batchHash The hash of the batch
  event CommitBatch(bytes32 indexed batchHash);

  /// @notice Emitted when a batch is reverted.
  /// @param batchHash The identification of the batch.
  event RevertBatch(bytes32 indexed batchHash);

  /// @notice Emitted when a batch is finalized.
  /// @param batchHash The hash of the batch
  event FinalizeBatch(bytes32 indexed batchHash);

  /***********
   * Structs *
   ***********/

  struct BlockContext {
    // The hash of this block.
    bytes32 blockHash;
    // The parent hash of this block.
    bytes32 parentHash;
    // The height of this block.
    uint64 blockNumber;
    // The timestamp of this block.
    uint64 timestamp;
    // The base fee of this block.
    // Currently, it is not used, because we disable EIP-1559.
    // We keep it for future proof.
    uint256 baseFee;
    // The gas limit of this block.
    uint64 gasLimit;
    // The number of transactions in this block, both L1 & L2 txs.
    uint16 numTransactions;
    // The number of l1 messages in this block.
    uint16 numL1Messages;
  }

  struct Batch {
    // The list of blocks in this batch
    BlockContext[] blocks; // MAX_NUM_BLOCKS = 100, about 5 min
    // The state root of previous batch.
    // The first batch will use 0x0 for prevStateRoot
    bytes32 prevStateRoot;
    // The state root of the last block in this batch.
    bytes32 newStateRoot;
    // The withdraw trie root of the last block in this batch.
    bytes32 withdrawTrieRoot;
    // The index of the batch.
    uint64 batchIndex;
    // The parent batch hash.
    bytes32 parentBatchHash;
    // Concatenated raw data of RLP encoded L2 txs
    bytes l2Transactions;
  }

  /*************************
   * Public View Functions *
   *************************/

  /// @notice Return whether the batch is finalized by batch hash.
  /// @param batchHash The hash of the batch to query.
  function isBatchFinalized(bytes32 batchHash) external view returns (bool);

  /// @notice Return the merkle root of L2 message tree.
  /// @param batchHash The hash of the batch to query.
  function getL2MessageRoot(bytes32 batchHash) external view returns (bytes32);

  /****************************
   * Public Mutated Functions *
   ****************************/

  /// @notice commit a batch in layer 1
  /// @param batch The layer2 batch to commit.
  function commitBatch(Batch memory batch) external;

  /// @notice commit a list of batches in layer 1
  /// @param batches The list of layer2 batches to commit.
  function commitBatches(Batch[] memory batches) external;

  /// @notice revert a pending batch.
  /// @dev one can only revert unfinalized batches.
  /// @param batchId The identification of the batch.
  function revertBatch(bytes32 batchId) external;

  /// @notice finalize commited batch in layer 1
  /// @dev will add more parameters if needed.
  /// @param batchId The identification of the commited batch.
  /// @param proof The corresponding proof of the commited batch.
  /// @param instances Instance used to verify, generated from batch.
  function finalizeBatchWithProof(
    bytes32 batchId,
    uint256[] memory proof,
    uint256[] memory instances
  ) external;
}

// File: src/libraries/verifier/RollupVerifier.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

library RollupVerifier {
  function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
    uint256 length = p1.length * 6;
    uint256[] memory input = new uint256[](length);
    uint256[1] memory result;
    bool ret;

    require(p1.length == p2.length);

    for (uint256 i = 0; i < p1.length; i++) {
      input[0 + i * 6] = p1[i].x;
      input[1 + i * 6] = p1[i].y;
      input[2 + i * 6] = p2[i].x[0];
      input[3 + i * 6] = p2[i].x[1];
      input[4 + i * 6] = p2[i].y[0];
      input[5 + i * 6] = p2[i].y[1];
    }

    assembly {
      ret := staticcall(gas(), 8, add(input, 0x20), mul(length, 0x20), result, 0x20)
    }
    require(ret);
    return result[0] != 0;
  }

  uint256 constant q_mod = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

  function fr_invert(uint256 a) internal view returns (uint256) {
    return fr_pow(a, q_mod - 2);
  }

  function fr_pow(uint256 a, uint256 power) internal view returns (uint256) {
    uint256[6] memory input;
    uint256[1] memory result;
    bool ret;

    input[0] = 32;
    input[1] = 32;
    input[2] = 32;
    input[3] = a;
    input[4] = power;
    input[5] = q_mod;

    assembly {
      ret := staticcall(gas(), 0x05, input, 0xc0, result, 0x20)
    }
    require(ret);

    return result[0];
  }

  function fr_div(uint256 a, uint256 b) internal view returns (uint256) {
    require(b != 0);
    return mulmod(a, fr_invert(b), q_mod);
  }

  function fr_mul_add(
    uint256 a,
    uint256 b,
    uint256 c
  ) internal pure returns (uint256) {
    return addmod(mulmod(a, b, q_mod), c, q_mod);
  }

  function fr_mul_add_pm(
    uint256[84] memory m,
    uint256[] calldata proof,
    uint256 opcode,
    uint256 t
  ) internal pure returns (uint256) {
    for (uint256 i = 0; i < 32; i += 2) {
      uint256 a = opcode & 0xff;
      if (a != 0xff) {
        opcode >>= 8;
        uint256 b = opcode & 0xff;
        opcode >>= 8;
        t = addmod(mulmod(proof[a], m[b], q_mod), t, q_mod);
      } else {
        break;
      }
    }

    return t;
  }

  function fr_mul_add_mt(
    uint256[84] memory m,
    uint256 base,
    uint256 opcode,
    uint256 t
  ) internal pure returns (uint256) {
    for (uint256 i = 0; i < 32; i += 1) {
      uint256 a = opcode & 0xff;
      if (a != 0xff) {
        opcode >>= 8;
        t = addmod(mulmod(base, t, q_mod), m[a], q_mod);
      } else {
        break;
      }
    }

    return t;
  }

  function fr_reverse(uint256 input) internal pure returns (uint256 v) {
    v = input;

    // swap bytes
    v =
      ((v & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00) >> 8) |
      ((v & 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) << 8);

    // swap 2-byte long pairs
    v =
      ((v & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000) >> 16) |
      ((v & 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) << 16);

    // swap 4-byte long pairs
    v =
      ((v & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000) >> 32) |
      ((v & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) << 32);

    // swap 8-byte long pairs
    v =
      ((v & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000) >> 64) |
      ((v & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) << 64);

    // swap 16-byte long pairs
    v = (v >> 128) | (v << 128);
  }

  uint256 constant p_mod = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

  struct G1Point {
    uint256 x;
    uint256 y;
  }

  struct G2Point {
    uint256[2] x;
    uint256[2] y;
  }

  function ecc_from(uint256 x, uint256 y) internal pure returns (G1Point memory r) {
    r.x = x;
    r.y = y;
  }

  function ecc_add(
    uint256 ax,
    uint256 ay,
    uint256 bx,
    uint256 by
  ) internal view returns (uint256, uint256) {
    bool ret = false;
    G1Point memory r;
    uint256[4] memory input_points;

    input_points[0] = ax;
    input_points[1] = ay;
    input_points[2] = bx;
    input_points[3] = by;

    assembly {
      ret := staticcall(gas(), 6, input_points, 0x80, r, 0x40)
    }
    require(ret);

    return (r.x, r.y);
  }

  function ecc_sub(
    uint256 ax,
    uint256 ay,
    uint256 bx,
    uint256 by
  ) internal view returns (uint256, uint256) {
    return ecc_add(ax, ay, bx, p_mod - by);
  }

  function ecc_mul(
    uint256 px,
    uint256 py,
    uint256 s
  ) internal view returns (uint256, uint256) {
    uint256[3] memory input;
    bool ret = false;
    G1Point memory r;

    input[0] = px;
    input[1] = py;
    input[2] = s;

    assembly {
      ret := staticcall(gas(), 7, input, 0x60, r, 0x40)
    }
    require(ret);

    return (r.x, r.y);
  }

  function _ecc_mul_add(uint256[5] memory input) internal view {
    bool ret = false;

    assembly {
      ret := staticcall(gas(), 7, input, 0x60, add(input, 0x20), 0x40)
    }
    require(ret);

    assembly {
      ret := staticcall(gas(), 6, add(input, 0x20), 0x80, add(input, 0x60), 0x40)
    }
    require(ret);
  }

  function ecc_mul_add(
    uint256 px,
    uint256 py,
    uint256 s,
    uint256 qx,
    uint256 qy
  ) internal view returns (uint256, uint256) {
    uint256[5] memory input;
    input[0] = px;
    input[1] = py;
    input[2] = s;
    input[3] = qx;
    input[4] = qy;

    _ecc_mul_add(input);

    return (input[3], input[4]);
  }

  function ecc_mul_add_pm(
    uint256[84] memory m,
    uint256[] calldata proof,
    uint256 opcode,
    uint256 t0,
    uint256 t1
  ) internal view returns (uint256, uint256) {
    uint256[5] memory input;
    input[3] = t0;
    input[4] = t1;
    for (uint256 i = 0; i < 32; i += 2) {
      uint256 a = opcode & 0xff;
      if (a != 0xff) {
        opcode >>= 8;
        uint256 b = opcode & 0xff;
        opcode >>= 8;
        input[0] = proof[a];
        input[1] = proof[a + 1];
        input[2] = m[b];
        _ecc_mul_add(input);
      } else {
        break;
      }
    }

    return (input[3], input[4]);
  }

  function update_hash_scalar(
    uint256 v,
    uint256[144] memory absorbing,
    uint256 pos
  ) internal pure {
    absorbing[pos++] = 0x02;
    absorbing[pos++] = v;
  }

  function update_hash_point(
    uint256 x,
    uint256 y,
    uint256[144] memory absorbing,
    uint256 pos
  ) internal pure {
    absorbing[pos++] = 0x01;
    absorbing[pos++] = x;
    absorbing[pos++] = y;
  }

  function to_scalar(bytes32 r) private pure returns (uint256 v) {
    uint256 tmp = uint256(r);
    tmp = fr_reverse(tmp);
    v = tmp % 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
  }

  function hash(uint256[144] memory absorbing, uint256 length) private view returns (bytes32[1] memory v) {
    bool success;
    assembly {
      success := staticcall(sub(gas(), 2000), 2, absorbing, length, v, 32)
      switch success
      case 0 {
        invalid()
      }
    }
    assert(success);
  }

  function squeeze_challenge(uint256[144] memory absorbing, uint32 length) internal view returns (uint256 v) {
    absorbing[length] = 0;
    bytes32 res = hash(absorbing, length * 32 + 1)[0];
    v = to_scalar(res);
    absorbing[0] = uint256(res);
    length = 1;
  }

  function get_verify_circuit_g2_s() internal pure returns (G2Point memory s) {
    s.x[0] = uint256(19996377281670978687180986182441301914718493784645870391946826878753710639456);
    s.x[1] = uint256(4287478848095488335912479212753150961411468232106701703291869721868407715111);
    s.y[0] = uint256(6995741485533723263267942814565501722132921805029874890336635619836737653877);
    s.y[1] = uint256(11126659726611658836425410744462014686753643655648740844565393330984713428953);
  }

  function get_verify_circuit_g2_n() internal pure returns (G2Point memory n) {
    n.x[0] = uint256(11559732032986387107991004021392285783925812861821192530917403151452391805634);
    n.x[1] = uint256(10857046999023057135944570762232829481370756359578518086990519993285655852781);
    n.y[0] = uint256(17805874995975841540914202342111839520379459829704422454583296818431106115052);
    n.y[1] = uint256(13392588948715843804641432497768002650278120570034223513918757245338268106653);
  }

  function get_target_circuit_g2_s() internal pure returns (G2Point memory s) {
    s.x[0] = uint256(19996377281670978687180986182441301914718493784645870391946826878753710639456);
    s.x[1] = uint256(4287478848095488335912479212753150961411468232106701703291869721868407715111);
    s.y[0] = uint256(6995741485533723263267942814565501722132921805029874890336635619836737653877);
    s.y[1] = uint256(11126659726611658836425410744462014686753643655648740844565393330984713428953);
  }

  function get_target_circuit_g2_n() internal pure returns (G2Point memory n) {
    n.x[0] = uint256(11559732032986387107991004021392285783925812861821192530917403151452391805634);
    n.x[1] = uint256(10857046999023057135944570762232829481370756359578518086990519993285655852781);
    n.y[0] = uint256(17805874995975841540914202342111839520379459829704422454583296818431106115052);
    n.y[1] = uint256(13392588948715843804641432497768002650278120570034223513918757245338268106653);
  }

  function get_wx_wg(uint256[] calldata proof, uint256[6] memory instances)
    internal
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    uint256[84] memory m;
    uint256[144] memory absorbing;
    uint256 t0 = 0;
    uint256 t1 = 0;

    (t0, t1) = (
      ecc_mul(
        16273630658577275004922498653030603356133576819117084202553121866583118864964,
        6490159372778831696763963776713702553449715395136256408127406430701013586737,
        instances[0]
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        21465583338900056601761668793508143213048509206826828900542864688378093593107,
        18916078441896187703473496284050716429170517783995157941513585201547834049281,
        instances[1],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        6343857336395576108841088300387244434710621968858839561085778033655098739860,
        8647137667680968494319179221347060255241434220013711910139382436020093396308,
        instances[2],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        17609998990685530094209191702545036897101285294398654477281719279316619940710,
        7891327626892441842954365090016786852185025910332850053066512639794082797200,
        instances[3],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        1271298011119556361067568041994358027954229594187408866479678256322993207430,
        16519855264988006509000373008036578681979317060055767197977112967887569978562,
        instances[4],
        t0,
        t1
      )
    );
    (m[0], m[1]) = (
      ecc_mul_add(
        9106880861932848269529912338578777683259870408474914617967634470292361865683,
        3191458938194545761508145121615374474619318896841102235687991186359560600763,
        instances[5],
        t0,
        t1
      )
    );
    update_hash_scalar(16714713909008743871958519800387174981836263428094013165455393524274317552599, absorbing, 0);
    update_hash_point(m[0], m[1], absorbing, 2);
    for (t0 = 0; t0 <= 4; t0++) {
      update_hash_point(proof[0 + t0 * 2], proof[1 + t0 * 2], absorbing, 5 + t0 * 3);
    }
    m[2] = (squeeze_challenge(absorbing, 20));
    for (t0 = 0; t0 <= 13; t0++) {
      update_hash_point(proof[10 + t0 * 2], proof[11 + t0 * 2], absorbing, 1 + t0 * 3);
    }
    m[3] = (squeeze_challenge(absorbing, 43));
    m[4] = (squeeze_challenge(absorbing, 1));
    for (t0 = 0; t0 <= 9; t0++) {
      update_hash_point(proof[38 + t0 * 2], proof[39 + t0 * 2], absorbing, 1 + t0 * 3);
    }
    m[5] = (squeeze_challenge(absorbing, 31));
    for (t0 = 0; t0 <= 3; t0++) {
      update_hash_point(proof[58 + t0 * 2], proof[59 + t0 * 2], absorbing, 1 + t0 * 3);
    }
    m[6] = (squeeze_challenge(absorbing, 13));
    for (t0 = 0; t0 <= 70; t0++) {
      update_hash_scalar(proof[66 + t0 * 1], absorbing, 1 + t0 * 2);
    }
    m[7] = (squeeze_challenge(absorbing, 143));
    for (t0 = 0; t0 <= 3; t0++) {
      update_hash_point(proof[137 + t0 * 2], proof[138 + t0 * 2], absorbing, 1 + t0 * 3);
    }
    m[8] = (squeeze_challenge(absorbing, 13));
    m[9] = (mulmod(m[6], 13446667982376394161563610564587413125564757801019538732601045199901075958935, q_mod));
    m[10] = (mulmod(m[6], 16569469942529664681363945218228869388192121720036659574609237682362097667612, q_mod));
    m[11] = (mulmod(m[6], 14803907026430593724305438564799066516271154714737734572920456128449769927233, q_mod));
    m[12] = (fr_pow(m[6], 67108864));
    m[13] = (addmod(m[12], q_mod - 1, q_mod));
    m[14] = (mulmod(21888242545679039938882419398440172875981108180010270949818755658014750055173, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 1, q_mod));
    m[14] = (fr_div(m[14], t0));
    m[15] = (mulmod(3495999257316610708652455694658595065970881061159015347599790211259094641512, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 14803907026430593724305438564799066516271154714737734572920456128449769927233, q_mod));
    m[15] = (fr_div(m[15], t0));
    m[16] = (mulmod(12851378806584061886934576302961450669946047974813165594039554733293326536714, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 11377606117859914088982205826922132024839443553408109299929510653283289974216, q_mod));
    m[16] = (fr_div(m[16], t0));
    m[17] = (mulmod(14638077285440018490948843142723135319134576188472316769433007423695824509066, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 3693565015985198455139889557180396682968596245011005461846595820698933079918, q_mod));
    m[17] = (fr_div(m[17], t0));
    m[18] = (mulmod(18027939092386982308810165776478549635922357517986691900813373197616541191289, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 17329448237240114492580865744088056414251735686965494637158808787419781175510, q_mod));
    m[18] = (fr_div(m[18], t0));
    m[19] = (mulmod(912591536032578604421866340844550116335029274442283291811906603256731601654, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 6047398202650739717314770882059679662647667807426525133977681644606291529311, q_mod));
    m[19] = (fr_div(m[19], t0));
    m[20] = (mulmod(17248638560015646562374089181598815896736916575459528793494921668169819478628, m[13], q_mod));
    t0 = (addmod(m[6], q_mod - 16569469942529664681363945218228869388192121720036659574609237682362097667612, q_mod));
    m[20] = (fr_div(m[20], t0));
    t0 = (addmod(m[15], m[16], q_mod));
    t0 = (addmod(t0, m[17], q_mod));
    t0 = (addmod(t0, m[18], q_mod));
    m[15] = (addmod(t0, m[19], q_mod));
    t0 = (fr_mul_add(proof[74], proof[72], proof[73]));
    t0 = (fr_mul_add(proof[75], proof[67], t0));
    t0 = (fr_mul_add(proof[76], proof[68], t0));
    t0 = (fr_mul_add(proof[77], proof[69], t0));
    t0 = (fr_mul_add(proof[78], proof[70], t0));
    m[16] = (fr_mul_add(proof[79], proof[71], t0));
    t0 = (mulmod(proof[67], proof[68], q_mod));
    m[16] = (fr_mul_add(proof[80], t0, m[16]));
    t0 = (mulmod(proof[69], proof[70], q_mod));
    m[16] = (fr_mul_add(proof[81], t0, m[16]));
    t0 = (addmod(1, q_mod - proof[97], q_mod));
    m[17] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[100], proof[100], q_mod));
    t0 = (addmod(t0, q_mod - proof[100], q_mod));
    m[18] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(proof[100], q_mod - proof[99], q_mod));
    m[19] = (mulmod(t0, m[14], q_mod));
    m[21] = (mulmod(m[3], m[6], q_mod));
    t0 = (addmod(m[20], m[15], q_mod));
    m[15] = (addmod(1, q_mod - t0, q_mod));
    m[22] = (addmod(proof[67], m[4], q_mod));
    t0 = (fr_mul_add(proof[91], m[3], m[22]));
    m[23] = (mulmod(t0, proof[98], q_mod));
    t0 = (addmod(m[22], m[21], q_mod));
    m[22] = (mulmod(t0, proof[97], q_mod));
    m[24] = (mulmod(4131629893567559867359510883348571134090853742863529169391034518566172092834, m[21], q_mod));
    m[25] = (addmod(proof[68], m[4], q_mod));
    t0 = (fr_mul_add(proof[92], m[3], m[25]));
    m[23] = (mulmod(t0, m[23], q_mod));
    t0 = (addmod(m[25], m[24], q_mod));
    m[22] = (mulmod(t0, m[22], q_mod));
    m[24] = (mulmod(4131629893567559867359510883348571134090853742863529169391034518566172092834, m[24], q_mod));
    m[25] = (addmod(proof[69], m[4], q_mod));
    t0 = (fr_mul_add(proof[93], m[3], m[25]));
    m[23] = (mulmod(t0, m[23], q_mod));
    t0 = (addmod(m[25], m[24], q_mod));
    m[22] = (mulmod(t0, m[22], q_mod));
    m[24] = (mulmod(4131629893567559867359510883348571134090853742863529169391034518566172092834, m[24], q_mod));
    t0 = (addmod(m[23], q_mod - m[22], q_mod));
    m[22] = (mulmod(t0, m[15], q_mod));
    m[21] = (mulmod(m[21], 11166246659983828508719468090013646171463329086121580628794302409516816350802, q_mod));
    m[23] = (addmod(proof[70], m[4], q_mod));
    t0 = (fr_mul_add(proof[94], m[3], m[23]));
    m[24] = (mulmod(t0, proof[101], q_mod));
    t0 = (addmod(m[23], m[21], q_mod));
    m[23] = (mulmod(t0, proof[100], q_mod));
    m[21] = (mulmod(4131629893567559867359510883348571134090853742863529169391034518566172092834, m[21], q_mod));
    m[25] = (addmod(proof[71], m[4], q_mod));
    t0 = (fr_mul_add(proof[95], m[3], m[25]));
    m[24] = (mulmod(t0, m[24], q_mod));
    t0 = (addmod(m[25], m[21], q_mod));
    m[23] = (mulmod(t0, m[23], q_mod));
    m[21] = (mulmod(4131629893567559867359510883348571134090853742863529169391034518566172092834, m[21], q_mod));
    m[25] = (addmod(proof[66], m[4], q_mod));
    t0 = (fr_mul_add(proof[96], m[3], m[25]));
    m[24] = (mulmod(t0, m[24], q_mod));
    t0 = (addmod(m[25], m[21], q_mod));
    m[23] = (mulmod(t0, m[23], q_mod));
    m[21] = (mulmod(4131629893567559867359510883348571134090853742863529169391034518566172092834, m[21], q_mod));
    t0 = (addmod(m[24], q_mod - m[23], q_mod));
    m[21] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[104], m[3], q_mod));
    m[23] = (mulmod(proof[103], t0, q_mod));
    t0 = (addmod(proof[106], m[4], q_mod));
    m[23] = (mulmod(m[23], t0, q_mod));
    m[24] = (mulmod(proof[67], proof[82], q_mod));
    m[2] = (mulmod(0, m[2], q_mod));
    m[24] = (addmod(m[2], m[24], q_mod));
    m[25] = (addmod(m[2], proof[83], q_mod));
    m[26] = (addmod(proof[104], q_mod - proof[106], q_mod));
    t0 = (addmod(1, q_mod - proof[102], q_mod));
    m[27] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[102], proof[102], q_mod));
    t0 = (addmod(t0, q_mod - proof[102], q_mod));
    m[28] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[24], m[3], q_mod));
    m[24] = (mulmod(proof[102], t0, q_mod));
    m[25] = (addmod(m[25], m[4], q_mod));
    t0 = (mulmod(m[24], m[25], q_mod));
    t0 = (addmod(m[23], q_mod - t0, q_mod));
    m[23] = (mulmod(t0, m[15], q_mod));
    m[24] = (mulmod(m[14], m[26], q_mod));
    t0 = (addmod(proof[104], q_mod - proof[105], q_mod));
    t0 = (mulmod(m[26], t0, q_mod));
    m[26] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[109], m[3], q_mod));
    m[29] = (mulmod(proof[108], t0, q_mod));
    t0 = (addmod(proof[111], m[4], q_mod));
    m[29] = (mulmod(m[29], t0, q_mod));
    m[30] = (fr_mul_add(proof[82], proof[68], m[2]));
    m[31] = (addmod(proof[109], q_mod - proof[111], q_mod));
    t0 = (addmod(1, q_mod - proof[107], q_mod));
    m[32] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[107], proof[107], q_mod));
    t0 = (addmod(t0, q_mod - proof[107], q_mod));
    m[33] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[30], m[3], q_mod));
    t0 = (mulmod(proof[107], t0, q_mod));
    t0 = (mulmod(t0, m[25], q_mod));
    t0 = (addmod(m[29], q_mod - t0, q_mod));
    m[29] = (mulmod(t0, m[15], q_mod));
    m[30] = (mulmod(m[14], m[31], q_mod));
    t0 = (addmod(proof[109], q_mod - proof[110], q_mod));
    t0 = (mulmod(m[31], t0, q_mod));
    m[31] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[114], m[3], q_mod));
    m[34] = (mulmod(proof[113], t0, q_mod));
    t0 = (addmod(proof[116], m[4], q_mod));
    m[34] = (mulmod(m[34], t0, q_mod));
    m[35] = (fr_mul_add(proof[82], proof[69], m[2]));
    m[36] = (addmod(proof[114], q_mod - proof[116], q_mod));
    t0 = (addmod(1, q_mod - proof[112], q_mod));
    m[37] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[112], proof[112], q_mod));
    t0 = (addmod(t0, q_mod - proof[112], q_mod));
    m[38] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[35], m[3], q_mod));
    t0 = (mulmod(proof[112], t0, q_mod));
    t0 = (mulmod(t0, m[25], q_mod));
    t0 = (addmod(m[34], q_mod - t0, q_mod));
    m[34] = (mulmod(t0, m[15], q_mod));
    m[35] = (mulmod(m[14], m[36], q_mod));
    t0 = (addmod(proof[114], q_mod - proof[115], q_mod));
    t0 = (mulmod(m[36], t0, q_mod));
    m[36] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[119], m[3], q_mod));
    m[39] = (mulmod(proof[118], t0, q_mod));
    t0 = (addmod(proof[121], m[4], q_mod));
    m[39] = (mulmod(m[39], t0, q_mod));
    m[40] = (fr_mul_add(proof[82], proof[70], m[2]));
    m[41] = (addmod(proof[119], q_mod - proof[121], q_mod));
    t0 = (addmod(1, q_mod - proof[117], q_mod));
    m[42] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[117], proof[117], q_mod));
    t0 = (addmod(t0, q_mod - proof[117], q_mod));
    m[43] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[40], m[3], q_mod));
    t0 = (mulmod(proof[117], t0, q_mod));
    t0 = (mulmod(t0, m[25], q_mod));
    t0 = (addmod(m[39], q_mod - t0, q_mod));
    m[25] = (mulmod(t0, m[15], q_mod));
    m[39] = (mulmod(m[14], m[41], q_mod));
    t0 = (addmod(proof[119], q_mod - proof[120], q_mod));
    t0 = (mulmod(m[41], t0, q_mod));
    m[40] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[124], m[3], q_mod));
    m[41] = (mulmod(proof[123], t0, q_mod));
    t0 = (addmod(proof[126], m[4], q_mod));
    m[41] = (mulmod(m[41], t0, q_mod));
    m[44] = (fr_mul_add(proof[84], proof[67], m[2]));
    m[45] = (addmod(m[2], proof[85], q_mod));
    m[46] = (addmod(proof[124], q_mod - proof[126], q_mod));
    t0 = (addmod(1, q_mod - proof[122], q_mod));
    m[47] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[122], proof[122], q_mod));
    t0 = (addmod(t0, q_mod - proof[122], q_mod));
    m[48] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[44], m[3], q_mod));
    m[44] = (mulmod(proof[122], t0, q_mod));
    t0 = (addmod(m[45], m[4], q_mod));
    t0 = (mulmod(m[44], t0, q_mod));
    t0 = (addmod(m[41], q_mod - t0, q_mod));
    m[41] = (mulmod(t0, m[15], q_mod));
    m[44] = (mulmod(m[14], m[46], q_mod));
    t0 = (addmod(proof[124], q_mod - proof[125], q_mod));
    t0 = (mulmod(m[46], t0, q_mod));
    m[45] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[129], m[3], q_mod));
    m[46] = (mulmod(proof[128], t0, q_mod));
    t0 = (addmod(proof[131], m[4], q_mod));
    m[46] = (mulmod(m[46], t0, q_mod));
    m[49] = (fr_mul_add(proof[86], proof[67], m[2]));
    m[50] = (addmod(m[2], proof[87], q_mod));
    m[51] = (addmod(proof[129], q_mod - proof[131], q_mod));
    t0 = (addmod(1, q_mod - proof[127], q_mod));
    m[52] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[127], proof[127], q_mod));
    t0 = (addmod(t0, q_mod - proof[127], q_mod));
    m[53] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[49], m[3], q_mod));
    m[49] = (mulmod(proof[127], t0, q_mod));
    t0 = (addmod(m[50], m[4], q_mod));
    t0 = (mulmod(m[49], t0, q_mod));
    t0 = (addmod(m[46], q_mod - t0, q_mod));
    m[46] = (mulmod(t0, m[15], q_mod));
    m[49] = (mulmod(m[14], m[51], q_mod));
    t0 = (addmod(proof[129], q_mod - proof[130], q_mod));
    t0 = (mulmod(m[51], t0, q_mod));
    m[50] = (mulmod(t0, m[15], q_mod));
    t0 = (addmod(proof[134], m[3], q_mod));
    m[51] = (mulmod(proof[133], t0, q_mod));
    t0 = (addmod(proof[136], m[4], q_mod));
    m[51] = (mulmod(m[51], t0, q_mod));
    m[54] = (fr_mul_add(proof[88], proof[67], m[2]));
    m[2] = (addmod(m[2], proof[89], q_mod));
    m[55] = (addmod(proof[134], q_mod - proof[136], q_mod));
    t0 = (addmod(1, q_mod - proof[132], q_mod));
    m[56] = (mulmod(m[14], t0, q_mod));
    t0 = (mulmod(proof[132], proof[132], q_mod));
    t0 = (addmod(t0, q_mod - proof[132], q_mod));
    m[20] = (mulmod(m[20], t0, q_mod));
    t0 = (addmod(m[54], m[3], q_mod));
    m[3] = (mulmod(proof[132], t0, q_mod));
    t0 = (addmod(m[2], m[4], q_mod));
    t0 = (mulmod(m[3], t0, q_mod));
    t0 = (addmod(m[51], q_mod - t0, q_mod));
    m[2] = (mulmod(t0, m[15], q_mod));
    m[3] = (mulmod(m[14], m[55], q_mod));
    t0 = (addmod(proof[134], q_mod - proof[135], q_mod));
    t0 = (mulmod(m[55], t0, q_mod));
    m[4] = (mulmod(t0, m[15], q_mod));
    t0 = (fr_mul_add(m[5], 0, m[16]));
    t0 = (fr_mul_add_mt(m, m[5], 24064768791442479290152634096194013545513974547709823832001394403118888981009, t0));
    t0 = (fr_mul_add_mt(m, m[5], 4704208815882882920750, t0));
    m[2] = (fr_div(t0, m[13]));
    m[3] = (mulmod(m[8], m[8], q_mod));
    m[4] = (mulmod(m[3], m[8], q_mod));
    (t0, t1) = (ecc_mul(proof[143], proof[144], m[4]));
    (t0, t1) = (ecc_mul_add_pm(m, proof, 281470825071501, t0, t1));
    (m[14], m[15]) = (ecc_add(t0, t1, proof[137], proof[138]));
    m[5] = (mulmod(m[4], m[11], q_mod));
    m[11] = (mulmod(m[4], m[7], q_mod));
    m[13] = (mulmod(m[11], m[7], q_mod));
    m[16] = (mulmod(m[13], m[7], q_mod));
    m[17] = (mulmod(m[16], m[7], q_mod));
    m[18] = (mulmod(m[17], m[7], q_mod));
    m[19] = (mulmod(m[18], m[7], q_mod));
    t0 = (mulmod(m[19], proof[135], q_mod));
    t0 = (fr_mul_add_pm(m, proof, 79227007564587019091207590530, t0));
    m[20] = (fr_mul_add(proof[105], m[4], t0));
    m[10] = (mulmod(m[3], m[10], q_mod));
    m[20] = (fr_mul_add(proof[99], m[3], m[20]));
    m[9] = (mulmod(m[8], m[9], q_mod));
    m[21] = (mulmod(m[8], m[7], q_mod));
    for (t0 = 0; t0 < 8; t0++) {
      m[22 + t0 * 1] = (mulmod(m[21 + t0 * 1], m[7 + t0 * 0], q_mod));
    }
    t0 = (mulmod(m[29], proof[133], q_mod));
    t0 = (fr_mul_add_pm(m, proof, 1461480058012745347196003969984389955172320353408, t0));
    m[20] = (addmod(m[20], t0, q_mod));
    m[3] = (addmod(m[3], m[21], q_mod));
    m[21] = (mulmod(m[7], m[7], q_mod));
    m[30] = (mulmod(m[21], m[7], q_mod));
    for (t0 = 0; t0 < 50; t0++) {
      m[31 + t0 * 1] = (mulmod(m[30 + t0 * 1], m[7 + t0 * 0], q_mod));
    }
    m[81] = (mulmod(m[80], proof[90], q_mod));
    m[82] = (mulmod(m[79], m[12], q_mod));
    m[83] = (mulmod(m[82], m[12], q_mod));
    m[12] = (mulmod(m[83], m[12], q_mod));
    t0 = (fr_mul_add(m[79], m[2], m[81]));
    t0 = (fr_mul_add_pm(m, proof, 28637501128329066231612878461967933875285131620580756137874852300330784214624, t0));
    t0 = (fr_mul_add_pm(m, proof, 21474593857386732646168474467085622855647258609351047587832868301163767676495, t0));
    t0 = (fr_mul_add_pm(m, proof, 14145600374170319983429588659751245017860232382696106927048396310641433325177, t0));
    t0 = (fr_mul_add_pm(m, proof, 18446470583433829957, t0));
    t0 = (addmod(t0, proof[66], q_mod));
    m[2] = (addmod(m[20], t0, q_mod));
    m[19] = (addmod(m[19], m[54], q_mod));
    m[20] = (addmod(m[29], m[53], q_mod));
    m[18] = (addmod(m[18], m[51], q_mod));
    m[28] = (addmod(m[28], m[50], q_mod));
    m[17] = (addmod(m[17], m[48], q_mod));
    m[27] = (addmod(m[27], m[47], q_mod));
    m[16] = (addmod(m[16], m[45], q_mod));
    m[26] = (addmod(m[26], m[44], q_mod));
    m[13] = (addmod(m[13], m[42], q_mod));
    m[25] = (addmod(m[25], m[41], q_mod));
    m[11] = (addmod(m[11], m[39], q_mod));
    m[24] = (addmod(m[24], m[38], q_mod));
    m[4] = (addmod(m[4], m[36], q_mod));
    m[23] = (addmod(m[23], m[35], q_mod));
    m[22] = (addmod(m[22], m[34], q_mod));
    m[3] = (addmod(m[3], m[33], q_mod));
    m[8] = (addmod(m[8], m[32], q_mod));
    (t0, t1) = (ecc_mul(proof[143], proof[144], m[5]));
    (t0, t1) = (
      ecc_mul_add_pm(m, proof, 10933423423422768024429730621579321771439401845242250760130969989159573132066, t0, t1)
    );
    (t0, t1) = (ecc_mul_add_pm(m, proof, 1461486238301980199876269201563775120819706402602, t0, t1));
    (t0, t1) = (
      ecc_mul_add(
        1166255827574633395469889753099263335112651429543747917860844891223509395230,
        18119530258797056675590474142263379269133137917926199526995010149706608452268,
        m[78],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        479654250230311733675045936187074887335076118790675548184957988765243051391,
        3100719863754926915077773261837642988281275398456491618898287285885297258973,
        m[77],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        3244117516185602927429536955777596704962143625995582449305913349309466588374,
        4949447249861524239830935874731901209583893161129086694779290040738731707868,
        m[76],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        14948547489533026990535642276664751166524290089518721217701084060838942037816,
        4158304819018152066924650590566402375351800342702049911667413813453648544913,
        m[75],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        12409839630787558779666051790740339639835641801241950167020910758875751567721,
        10190386726927990167988725115981898191213252554332296547744162818590468069671,
        m[74],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        17970998203939514710036667497443822563987440725661639935300105673829885028203,
        5681616020208389658397995048088678631695525787311431942560298329387592854586,
        m[73],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        5422170891120229182360564594866246906567981360038071999127508208070564034524,
        14722029885921976755274052080011416898514630484317773275415621146460924728182,
        m[72],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        3955318928206501525438681058758319558200398421433597349851235741670899388496,
        15892053452767975688653514510353871405466169306176036727161401156637227884251,
        m[71],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        18451207565454686459225553564649439057698581050443267052774483067774590965003,
        4419693978684087696088612463773850574955779922948673330581664932100506990694,
        m[70],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        847101878434221983907574308143360385944534458215526175646288607915875901481,
        2846353475656269162370753247605184679473264230467654203502980134120309217445,
        m[69],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        5422170891120229182360564594866246906567981360038071999127508208070564034524,
        14722029885921976755274052080011416898514630484317773275415621146460924728182,
        m[68],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        12355852135968866678343538084506414981897123075397230437920965961095525036339,
        19173350083521771086213125757940272853888577158427508914933730457941026326040,
        m[67],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        21537162186981550637121053147454964150809482185492418377558290311964245821909,
        2173324946696678910860567153502925685634606622474439126082176533839311460335,
        m[66],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        20702481083445183838662364419201395944400358423071711333544748994437443350157,
        21729036491728923882358088642589857779818948470983153549909552615176584955200,
        m[65],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        5211075648402252045446907842677410998750480902260529776286467677659191740672,
        17759936859541227097052484319437171023743724174885338509498798745592136568923,
        m[64],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        5685082624811934526131077036509066197941130699019907200139767495570575867807,
        9975752329518147542127949868789945608848626426600733728808879384778577859545,
        m[63],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        1845955600044282712468400114813806019045133083112296001842856684609288249746,
        6677624509889210837770197526955652810854887548330294041671470991988491766303,
        m[62],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        17721426954552427189787075605835833086212392642349293317822925006771731953198,
        10818582862561493154030196266254401851195091198556669943079029419869326006448,
        m[61],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        10224195420706066705577574946990328089867884648164309818089282930621493257750,
        3961164971057442035153270823831734824136501489880082889417523554417504868473,
        m[60],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        4155760488117491189818018229959225087159948854404593659816501566044290851616,
        7849169269773333823959590214273366557169699873629739076719523623811579483219,
        m[59],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        9303688548891777886487749234688027352493881691026887577351708905397127609597,
        15420408437274623857443274867832176492025874147466147921781316121716419230415,
        m[58],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        1713011977361327447402228333889074876456179272285913377605323580535155713105,
        17494574374943878587945090358233307058027002207479570017169918665020362475592,
        m[57],
        t0,
        t1
      )
    );
    (t0, t1) = (
      ecc_mul_add(
        688560977158667877997491129442687540611216305867558421257325952561991356422,
        1877117185103259325255107191485730322497880777053300656925558921917058739650,
        m[56],
        t0,
        t1
      )
    );
    (t0, t1) = (ecc_mul_add_pm(m, proof, 6277008573546246765208814532330797927747086570010716419876, t0, t1));
    (m[0], m[1]) = (ecc_add(t0, t1, m[0], m[1]));
    (t0, t1) = (ecc_mul(1, 2, m[2]));
    (m[0], m[1]) = (ecc_sub(m[0], m[1], t0, t1));
    return (m[14], m[15], m[0], m[1]);
  }

  function verify(uint256[] calldata proof, uint256[] calldata target_circuit_final_pair) public view {
    uint256[6] memory instances;
    instances[0] = target_circuit_final_pair[0] & ((1 << 136) - 1);
    instances[1] = (target_circuit_final_pair[0] >> 136) + ((target_circuit_final_pair[1] & 1) << 136);
    instances[2] = target_circuit_final_pair[2] & ((1 << 136) - 1);
    instances[3] = (target_circuit_final_pair[2] >> 136) + ((target_circuit_final_pair[3] & 1) << 136);

    instances[4] = target_circuit_final_pair[4];
    instances[5] = target_circuit_final_pair[5];

    uint256 x0 = 0;
    uint256 x1 = 0;
    uint256 y0 = 0;
    uint256 y1 = 0;

    G1Point[] memory g1_points = new G1Point[](2);
    G2Point[] memory g2_points = new G2Point[](2);
    bool checked = false;

    (x0, y0, x1, y1) = get_wx_wg(proof, instances);
    g1_points[0].x = x0;
    g1_points[0].y = y0;
    g1_points[1].x = x1;
    g1_points[1].y = y1;
    g2_points[0] = get_verify_circuit_g2_s();
    g2_points[1] = get_verify_circuit_g2_n();

    checked = pairing(g1_points, g2_points);
    require(checked);

    g1_points[0].x = target_circuit_final_pair[0];
    g1_points[0].y = target_circuit_final_pair[1];
    g1_points[1].x = target_circuit_final_pair[2];
    g1_points[1].y = target_circuit_final_pair[3];
    g2_points[0] = get_target_circuit_g2_s();
    g2_points[1] = get_target_circuit_g2_n();

    checked = pairing(g1_points, g2_points);
    require(checked);
  }
}

// File: src/L1/rollup/ScrollChain.sol



pragma solidity ^0.8.0;



// solhint-disable reason-string

/// @title ScrollChain
/// @notice This contract maintains essential data for scroll rollup, including:
///
/// 1. a list of pending messages, which will be relayed to layer 2;
/// 2. the block tree generated by layer 2 and it's status.
///
/// @dev the message queue is not used yet, the offline relayer only use events in `L1ScrollMessenger`.
contract ScrollChain is OwnableUpgradeable, IScrollChain {
  /**********
   * Events *
   **********/

  /// @notice Emitted when owner updates the status of sequencer.
  /// @param account The address of account updated.
  /// @param status The status of the account updated.
  event UpdateSequencer(address indexed account, bool status);

  /*************
   * Constants *
   *************/

  /// @dev The maximum number of transaction in on batch.
  uint256 public immutable maxNumTxInBatch;

  /// @dev The hash used for padding public inputs.
  bytes32 public immutable paddingTxHash;

  /// @notice The chain id of the corresponding layer 2 chain.
  uint256 public immutable layer2ChainId;

  /***********
   * Structs *
   ***********/

  // subject to change
  struct BatchStored {
    // The state root of the last block in this batch.
    bytes32 newStateRoot;
    // The withdraw trie root of the last block in this batch.
    bytes32 withdrawTrieRoot;
    // The parent batch hash.
    bytes32 parentBatchHash;
    // The index of the batch.
    uint64 batchIndex;
    // The timestamp of the last block in this batch.
    uint64 timestamp;
    // The number of transactions in this batch, both L1 & L2 txs.
    uint64 numTransactions;
    // The total number of L1 messages included after this batch.
    uint64 totalL1Messages;
    // Whether the batch is finalized.
    bool finalized;
  }

  /*************
   * Variables *
   *************/

  /// @notice The address of L1MessageQueue.
  address public messageQueue;

  /// @notice Whether an account is a sequencer.
  mapping(address => bool) public isSequencer;

  /// @notice The latest finalized batch hash.
  bytes32 public lastFinalizedBatchHash;

  /// @notice Mapping from batch id to batch struct.
  mapping(bytes32 => BatchStored) public batches;

  /// @notice Mapping from batch index to finalized batch hash.
  mapping(uint256 => bytes32) public finalizedBatches;

  /**********************
   * Function Modifiers *
   **********************/

  modifier OnlySequencer() {
    // @todo In the decentralize mode, it should be only called by a list of validator.
    require(isSequencer[msg.sender], "caller not sequencer");
    _;
  }

  /***************
   * Constructor *
   ***************/

  constructor(
    uint256 _chainId,
    uint256 _maxNumTxInBatch,
    bytes32 _paddingTxHash
  ) {
    layer2ChainId = _chainId;
    maxNumTxInBatch = _maxNumTxInBatch;
    paddingTxHash = _paddingTxHash;
  }

  function initialize(address _messageQueue) public initializer {
    OwnableUpgradeable.__Ownable_init();

    messageQueue = _messageQueue;
  }

  /*************************
   * Public View Functions *
   *************************/

  /// @inheritdoc IScrollChain
  function isBatchFinalized(bytes32 _batchHash) external view override returns (bool) {
    BatchStored storage _batch = batches[_batchHash];
    if (_batch.newStateRoot == bytes32(0)) {
      return false;
    }
    return batches[lastFinalizedBatchHash].batchIndex >= _batch.batchIndex;
  }

  /// @inheritdoc IScrollChain
  function getL2MessageRoot(bytes32 _batchHash) external view override returns (bytes32) {
    return batches[_batchHash].withdrawTrieRoot;
  }

  /****************************
   * Public Mutated Functions *
   ****************************/

  /// @notice Import layer 2 genesis block
  function importGenesisBatch(Batch memory _genesisBatch) external {
    require(lastFinalizedBatchHash == bytes32(0), "Genesis batch imported");
    require(_genesisBatch.blocks.length == 1, "Not exact one block in genesis");
    require(_genesisBatch.prevStateRoot == bytes32(0), "Nonzero prevStateRoot");

    BlockContext memory _genesisBlock = _genesisBatch.blocks[0];

    require(_genesisBlock.blockHash != bytes32(0), "Block hash is zero");
    require(_genesisBlock.blockNumber == 0, "Block is not genesis");
    require(_genesisBlock.parentHash == bytes32(0), "Parent hash not empty");

    bytes32 _batchHash = _commitBatch(_genesisBatch);

    lastFinalizedBatchHash = _batchHash;
    finalizedBatches[0] = _batchHash;
    batches[_batchHash].finalized = true;

    emit FinalizeBatch(_batchHash);
  }

  /// @inheritdoc IScrollChain
  function commitBatch(Batch memory _batch) public override OnlySequencer {
    _commitBatch(_batch);
  }

  /// @inheritdoc IScrollChain
  function commitBatches(Batch[] memory _batches) public override OnlySequencer {
    for (uint256 i = 0; i < _batches.length; i++) {
      _commitBatch(_batches[i]);
    }
  }

  /// @inheritdoc IScrollChain
  function revertBatch(bytes32 _batchHash) external override OnlySequencer {
    BatchStored storage _batch = batches[_batchHash];

    require(_batch.newStateRoot != bytes32(0), "No such batch");
    require(!_batch.finalized, "Unable to revert finalized batch");

    // delete committed batch
    delete batches[_batchHash];

    emit RevertBatch(_batchHash);
  }

  /// @inheritdoc IScrollChain
  function finalizeBatchWithProof(
    bytes32 _batchHash,
    uint256[] memory _proof,
    uint256[] memory _instances
  ) external override OnlySequencer {
    BatchStored storage _batch = batches[_batchHash];
    require(_batch.newStateRoot != bytes32(0), "No such batch");
    require(!_batch.finalized, "Batch is already finalized");

    // @note skip parent check for now, since we may not prove blocks in order.
    // bytes32 _parentHash = _block.header.parentHash;
    // require(lastFinalizedBlockHash == _parentHash, "parent not latest finalized");
    // this check below is not needed, just incase
    // require(blocks[_parentHash].verified, "parent not verified");

    // @todo add verification logic
    // RollupVerifier.verify(_proof, _instances);

    uint256 _batchIndex = _batch.batchIndex;
    finalizedBatches[_batchIndex] = _batchHash;
    _batch.finalized = true;

    BatchStored storage _finalizedBatch = batches[lastFinalizedBatchHash];
    if (_batchIndex > _finalizedBatch.batchIndex) {
      lastFinalizedBatchHash = _batchHash;
    }

    emit FinalizeBatch(_batchHash);
  }

  /************************
   * Restricted Functions *
   ************************/

  /// @notice Update the status of sequencer.
  /// @dev This function can only called by contract owner.
  /// @param _account The address of account to update.
  /// @param _status The status of the account to update.
  function updateSequencer(address _account, bool _status) external onlyOwner {
    isSequencer[_account] = _status;

    emit UpdateSequencer(_account, _status);
  }

  /**********************
   * Internal Functions *
   **********************/

  /// @dev Internal function to commit a batch.
  /// @param _batch The batch to commit.
  function _commitBatch(Batch memory _batch) internal returns (bytes32) {
    // check whether the batch is empty
    require(_batch.blocks.length > 0, "Batch is empty");

    BatchStored storage _parentBatch = batches[_batch.parentBatchHash];
    require(_parentBatch.newStateRoot == _batch.prevStateRoot, "prevStateRoot is different from newStateRoot in the parent batch");
    uint64 accTotalL1Messages = _parentBatch.totalL1Messages;

    bytes32 publicInputHash;
    uint64 numTransactionsInBatch;
    uint64 lastBlockTimestamp;
    (publicInputHash, numTransactionsInBatch, accTotalL1Messages, lastBlockTimestamp) = computePublicInputHash(
      accTotalL1Messages,
      _batch
    );

    BatchStored storage _batchInStorage = batches[publicInputHash];

    require(_batchInStorage.newStateRoot == bytes32(0), "Batch already commited");
    _batchInStorage.newStateRoot = _batch.newStateRoot;
    _batchInStorage.withdrawTrieRoot = _batch.withdrawTrieRoot;
    _batchInStorage.batchIndex = _batch.batchIndex;
    _batchInStorage.parentBatchHash = _batch.parentBatchHash;
    _batchInStorage.timestamp = lastBlockTimestamp;
    _batchInStorage.numTransactions = numTransactionsInBatch;
    _batchInStorage.totalL1Messages = accTotalL1Messages;

    emit CommitBatch(publicInputHash);

    return publicInputHash;
  }

  /// @dev Internal function to compute the public input hash.
  /// @param accTotalL1Messages The number of total L1 messages in previous batch.
  /// @param batch The batch to compute.
  function computePublicInputHash(uint64 accTotalL1Messages, Batch memory batch)
    public
    view
    returns (
      bytes32,
      uint64,
      uint64,
      uint64
    )
  {
    uint256 publicInputsPtr;
    // 1. append prevStateRoot, newStateRoot and withdrawTrieRoot to public inputs
    {
      bytes32 prevStateRoot = batch.prevStateRoot;
      bytes32 newStateRoot = batch.newStateRoot;
      bytes32 withdrawTrieRoot = batch.withdrawTrieRoot;
      // number of bytes in public inputs: 32 * 3 + 124 * blocks + 32 * MAX_NUM_TXS
      uint256 publicInputsSize = 32 * 3 + batch.blocks.length * 124 + 32 * maxNumTxInBatch;
      assembly {
        publicInputsPtr := mload(0x40)
        mstore(0x40, add(publicInputsPtr, publicInputsSize))
        mstore(publicInputsPtr, prevStateRoot)
        publicInputsPtr := add(publicInputsPtr, 0x20)
        mstore(publicInputsPtr, newStateRoot)
        publicInputsPtr := add(publicInputsPtr, 0x20)
        mstore(publicInputsPtr, withdrawTrieRoot)
        publicInputsPtr := add(publicInputsPtr, 0x20)
      }
    }

    uint64 numTransactionsInBatch;
    BlockContext memory _block;
    // 2. append block information to public inputs.
    for (uint256 i = 0; i < batch.blocks.length; i++) {
      // validate blocks, we won't check first block against previous batch.
      {
        BlockContext memory _currentBlock = batch.blocks[i];
        if (i > 0) {
          require(_block.blockHash == _currentBlock.parentHash, "Parent hash mismatch");
          require(_block.blockNumber + 1 == _currentBlock.blockNumber, "Block number mismatch");
        }
        _block = _currentBlock;
      }

      // append blockHash and parentHash to public inputs
      {
        bytes32 blockHash = _block.blockHash;
        bytes32 parentHash = _block.parentHash;
        assembly {
          mstore(publicInputsPtr, blockHash)
          publicInputsPtr := add(publicInputsPtr, 0x20)
          mstore(publicInputsPtr, parentHash)
          publicInputsPtr := add(publicInputsPtr, 0x20)
        }
      }
      // append blockNumber and blockTimestamp to public inputs
      {
        uint256 blockNumber = _block.blockNumber;
        uint256 blockTimestamp = _block.timestamp;
        assembly {
          mstore(publicInputsPtr, shl(192, blockNumber))
          publicInputsPtr := add(publicInputsPtr, 0x8)
          mstore(publicInputsPtr, shl(192, blockTimestamp))
          publicInputsPtr := add(publicInputsPtr, 0x8)
        }
      }
      // append baseFee to public inputs
      {
        uint256 baseFee = _block.baseFee;
        assembly {
          mstore(publicInputsPtr, baseFee)
          publicInputsPtr := add(publicInputsPtr, 0x20)
        }
      }
      uint64 numTransactionsInBlock = _block.numTransactions;
      // gasLimit, numTransactions and numL1Messages to public inputs
      {
        uint256 gasLimit = _block.gasLimit;
        uint256 numL1MessagesInBlock = _block.numL1Messages;
        assembly {
          mstore(publicInputsPtr, shl(192, gasLimit))
          publicInputsPtr := add(publicInputsPtr, 0x8)
          mstore(publicInputsPtr, shl(240, numTransactionsInBlock))
          publicInputsPtr := add(publicInputsPtr, 0x2)
          mstore(publicInputsPtr, shl(240, numL1MessagesInBlock))
          publicInputsPtr := add(publicInputsPtr, 0x2)
        }
      }
      numTransactionsInBatch += numTransactionsInBlock;
    }
    require(numTransactionsInBatch <= maxNumTxInBatch, "Too many transactions in batch");

    // 3. append transaction hash to public inputs.
    address _messageQueue = messageQueue;
    uint256 _l2TxnPtr;
    {
      bytes memory l2Transactions = batch.l2Transactions;
      assembly {
        _l2TxnPtr := add(l2Transactions, 0x20)
      }
    }
    for (uint256 i = 0; i < batch.blocks.length; i++) {
      uint256 numL1MessagesInBlock = batch.blocks[i].numL1Messages;
      while (numL1MessagesInBlock > 0) {
        bytes32 hash = IL1MessageQueue(_messageQueue).getCrossDomainMessage(uint64(accTotalL1Messages));
        assembly {
          mstore(publicInputsPtr, hash)
          publicInputsPtr := add(publicInputsPtr, 0x20)
        }
        unchecked {
          accTotalL1Messages += 1;
          numL1MessagesInBlock -= 1;
        }
      }
      numL1MessagesInBlock = batch.blocks[i].numL1Messages;
      uint256 numTransactionsInBlock = batch.blocks[i].numTransactions;
      for (uint256 j = numL1MessagesInBlock; j < numTransactionsInBlock; ++j) {
        bytes32 hash;
        assembly {
          let txPayloadLength := shr(224, mload(_l2TxnPtr))
          _l2TxnPtr := add(_l2TxnPtr, 4)
          _l2TxnPtr := add(_l2TxnPtr, txPayloadLength)
          hash := keccak256(sub(_l2TxnPtr, txPayloadLength), txPayloadLength)
          mstore(publicInputsPtr, hash)
          publicInputsPtr := add(publicInputsPtr, 0x20)
        }
      }
    }

    // 4. append padding transaction to public inputs.
    bytes32 txHashPadding = paddingTxHash;
    for (uint256 i = numTransactionsInBatch; i < maxNumTxInBatch; i++) {
      assembly {
        mstore(publicInputsPtr, txHashPadding)
        publicInputsPtr := add(publicInputsPtr, 0x20)
      }
    }

    // 5. compute public input hash
    bytes32 publicInputHash;
    {
      uint256 publicInputsSize = 32 * 3 + batch.blocks.length * 124 + 32 * maxNumTxInBatch;
      assembly {
        publicInputHash := keccak256(sub(publicInputsPtr, publicInputsSize), publicInputsSize)
      }
    }

    return (publicInputHash, numTransactionsInBatch, accTotalL1Messages, _block.timestamp);
  }
}