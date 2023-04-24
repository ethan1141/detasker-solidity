// Sources flattened with hardhat v2.13.1 https://hardhat.org

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.2

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.2

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// File @openzeppelin/contracts/utils/Context.sol@v4.8.2

// SPDX-License-Identifier: MIT
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
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.2

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.2

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


// File contracts/Detasker.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
/**
 * @title Detasker - a simple smart contract to facilitate users in web3 anouncing jobs and/or skills
 * @author Ethan Russell <ethanrussell.dev>
 * @notice
 */



// library utils {
//     function getSecondsPerDay() internal pure returns (uint256) {
//         return 86400;
//     }

//     function getTimeForConformation(uint _days) public pure returns (uint256) {
//         return getSecondsPerDay() * _days;
//     }
// }

contract Detasker is ERC20("Detasker", "dtsk") {
    mapping(address => Profile) public users;
    Item public vars;
    uint public timeForConformation = getConformationDays(30);
    event PaidForAJob(uint amount, uint timestamp);
    event CompletingJob(
        address whoItFor,
        address whoCompletedIt,
        uint forAmount,
        bool waitForConformation
    );
    struct Item {
        address owner;
        Job[] jobs;
        Rating[] ratings;
        Skill[] skills;
        Dispute[] dispute;
        Freelance[] freelance;
        uint256 jobCount;
        uint256 freelanceCount;
        uint256 ratingCount;
        uint256 tagCount;
        uint256 skillCount;
        uint256 userCount;
        address bnbToken;
    }
    struct Dispute {
        string reason;
        uint timestamp;
    }
    struct Freelance {
        uint256 id;
        bool isFreelancer;
        bool active;
        string mainSkills;
        uint256[] skillsId;
    }
    struct Job {
        bool hasFunds;
        uint256 id;
        uint256 profileId;
        string title;
        string description;
        string[] img; // with greenfield
        address owner;
        address requester;
        uint256 postedDate;
        uint256 date;
        uint256 datePaid;
        string documents;
        uint256 requestedPaymentAmount;
        address token;
        uint256[] tags;
        bool publish;
        bool completed;
        bool paid;
        bool assigned;
        uint256 dateCompleted;
        uint256 datePublished;
        uint256[] dispute;
        bool deleted;
    }

    struct Tag {
        uint256 id;
        string name;
    }

    struct ShowcaseWork {
        uint256 id;
        string description;
        string url;
    }

    struct Rating {
        uint256 id;
        uint8 rating;
        string review;
        uint256 jobId;
    }

    struct Skill {
        uint256 id;
        uint256 profileId;
        string skill;
        string skillName;
        string url;
        address user;
    }

    struct Profile {
        uint256 id;
        uint256 freeLanceId;
        string name;
        string email;
        Social[] socials;
        uint256 signedUp;
        string image;
        uint256[] jobsId;
        uint256[] ratings;
        mapping(address => uint256) escrow;
    }

    struct NewProfile {
        string name;
        string email;
        Freelance freelance;
        string image;
        Social[] socials; // 2D array [ 0: [ name, url ] ]
        ShowcaseWork[] showcaseWork;
        Skill[] skills;
    }

    struct Social {
        string name;
        string url;
    }

    function getUserCount() public view returns (uint256) {
        return vars.userCount;
    }

    function getOwner() public view returns (address) {
        return vars.owner;
    }

    function getConformationDays(uint256 _days) public pure returns (uint256) {
        return 86400 * _days;
    }

    constructor(address _owner) {
        vars.owner = _owner;
        vars.bnbToken = address(0xEE786A1aA32fc164cca9A28F763Fbc835E748129); //
    }

    // function postAJob(Job memory _job) public {
    //     vars.jobCount++;
    //     _job.datePublished = (_job.publish ? block.timestamp : 0);

    //     _job.owner = msg.sender;
    //     vars.jobs[vars.jobCount] = _job;
    //     users[msg.sender].jobsId.push(vars.jobCount);
    // }

    function createFreelance(
        address _address,
        Freelance memory freelance
    ) public {
        require(
            users[_address].freeLanceId != 0,
            "Please go through the update method"
        );
        vars.freelanceCount++;
        freelance.id = vars.freelanceCount;
        vars.freelance.push(freelance);
        users[_address].freeLanceId = vars.freelanceCount;
    }

    function createUser(address _address, NewProfile memory _profile) public {
        vars.userCount++;
        users[_address].id = vars.userCount;
        users[_address].name = _profile.name;
        users[_address].name = _profile.email;
        users[_address].signedUp = block.timestamp;
        users[_address].image = _profile.image;
        createFreelance(_address, _profile.freelance);

        if (_profile.skills.length != 0) {
            for (uint i = 0; i < _profile.skills.length; i++) {
                this.createSkill(_address, _profile.skills[i]);
            }
        }
        if (_profile.socials.length != 0) {
            for (uint i = 0; i < _profile.socials.length; i++) {
                this.createSocial(_address, _profile.socials[i]);
            }
        }
        // if (_profile.skills.length != 0) {
        //     for (uint i = 0; i < _profile.skills.length; i++) {
        //         this.createSkill(_address, _profile.skills[i]);
        //     }
        // }
        // if (_profile.skills.length != 0) {
        //     for (uint i = 0; i < _profile.skills.length; i++) {
        //         this.createSkill(_address, _profile.skills[i]);
        //     }
        // }
        // users[_address].socials = _profile.socials;
        // users[_address].showcaseWork = _profile.showcaseWork;
        // users[_address].jobsId = _profile.jobsId;
        // users[_address].ratings = _profile.ratings;
        // users[_address].skills = _profile.skills;
        // );
        // users[_address] = _profile;
    }

    function createSkill(address _address, Skill memory _skill) public {
        uint256 id = vars.skillCount++;
        _skill.id = id;
        _skill.user = _address;
        vars.freelance[users[_address].freeLanceId].skillsId.push(id);
        vars.skills[id] = _skill;
        vars.skillCount = id;
    }

    function createSocial(address _address, Social memory _social) public {
        users[_address].socials.push(_social);
    }

    function createJob(address _address, Job memory _job) public {
        vars.jobCount++;
        _job.id = vars.jobCount;
        if (_job.publish) {
            _job.postedDate = block.timestamp;
        }
        _job.owner = _address;
        users[_address].jobsId.push(vars.jobCount);
        vars.jobs[vars.jobCount] = _job;
    }

    function completeJob(
        address _address,
        Rating memory _rating,
        uint256 jobId
    ) public {
        Job memory _job = getJobById(jobId);
        require(_job.requester == _address, "This isn't your assigned job");
        require(
            _rating.rating >= 0 && _rating.rating <= 5,
            "Please give this job a rating out of 5"
        );

        vars.ratingCount++;
        _rating.id = vars.ratingCount;
        vars.ratings[vars.ratingCount] = _rating;

        emit CompletingJob(
            _job.owner,
            _job.requester,
            _job.requestedPaymentAmount,
            true
        );
    }

    // function dispueAJob(string calldata _reason, uint256 _jobId) external {
    //     Job memory _job = getJobById(_jobId);
    //     _job.dispute[_job.dispute.length] = Dispute(_reason, block.timestamp);
    //     _job.completed = false;
    //     setJobById(_job);
    // }

    function assignJob(address _address, uint jobId) public {
        Job memory _job = getJobById(jobId);
        _job.assigned = true;
        _job.requester = _address;
        setJobById(_job);
    }

    function getJobById(uint256 _jobId) public view returns (Job memory) {
        Job memory _job = vars.jobs[_jobId];
        require(_job.id > 0, "Unable to get a job with that id");
        return _job;
    }

    function getJobById(
        uint256 _jobId,
        address _address
    ) public view returns (Job memory) {
        Job memory _job = vars.jobs[_jobId];
        require(_job.id > 0, "Unable to get a job with that id");
        require(_job.owner == _address, "This isn't your assigned job");
        return _job;
    }

    function setJobById(Job memory _job) private {
        vars.jobs[_job.id] = _job;
    }

    function payForJobByOwner(uint256 _jobId) public payable {
        Job memory _job = getJobById(_jobId);
        require(!_job.paid, "This job has alread been paid");
        require(
            !_job.completed,
            "wait for the assignee to confirm completeness"
        );
        require(_job.owner == msg.sender, "You don't own this job");
        ownerWithdraw(_job.token, _jobId);
        emit PaidForAJob(_job.requestedPaymentAmount, block.timestamp);
    }

    function recievePaymentForJobByRequester(uint256 _jobId) public payable {
        Job memory _job = getJobById(_jobId);
        require(!_job.paid, "This job has alread been paid");
        require(
            !_job.completed,
            "wait for the assignee to confirm completeness"
        );
        require(
            _job.requester != msg.sender,
            "You are not assigned to this job"
        );
        jobWithdraw(_job.token, _jobId);
        emit PaidForAJob(_job.requestedPaymentAmount, block.timestamp);
    }

    function setJobDoneByOwner(address _address, uint256 jobId) public {
        Job memory _job = getJobById(jobId, _address);
        _job.completed = true;
        _job.dateCompleted = block.timestamp;
        setJobById(_job);
    }

    function setJobDoneByRequester(address _address, uint256 jobId) public {
        Job memory _job = getJobById(jobId);
        require(_job.requester == _address, "You don't own this job");
        _job.completed = true;
        _job.dateCompleted = block.timestamp;
        setJobById(_job);
    }

    function approveTokenSpend(
        address _token,
        address spender,
        uint amount
    ) public returns (bool) {
        return ERC20(_token).approve(spender, amount);
    }

    function allowance(
        address _address,
        address _token
    ) public view override returns (uint256) {
        return ERC20(_token).allowance(address(this), _address);
    }

    function Jobdeposit(address _token, uint256 jobId) public payable {
        Job memory _job = getJobById(jobId, msg.sender);
        require(
            IERC20(_token).allowance(msg.sender, address(this)) < msg.value,
            "Amount approved is less then token transferred amount to contract"
        );
        if (msg.value >= _job.requestedPaymentAmount) {
            IERC20(_token).transfer(address(this), msg.value);
            users[msg.sender].escrow[_token] += msg.value;
            _job.token = _token;
            _job.hasFunds = true;
            setJobById(_job);
        }
    }

    function jobWithdraw(address _token, uint256 jobId) public payable {
        Job memory _job = getJobById(jobId);
        require(
            IERC20(_token).allowance(address(this), msg.sender) < msg.value,
            "Amount approved is less then token transferred amount"
        );
        if (msg.value >= _job.requestedPaymentAmount) {
            IERC20(_token).transferFrom(address(this), msg.sender, msg.value);
            users[msg.sender].escrow[_token] -= msg.value;
            _job.paid = true;
            _job.datePaid = block.timestamp;
            setJobById(_job);
        }
    }

    /**
     *
     * @param _token s
     * @param jobId we
     */
    function ownerWithdraw(address _token, uint256 jobId) public payable {
        Job memory _job = getJobById(jobId);
        require(
            IERC20(_token).allowance(address(this), _job.owner) < msg.value,
            "Amount approved is less then token transferred amount"
        );
        if (msg.value >= _job.requestedPaymentAmount) {
            IERC20(_token).transferFrom(address(this), _job.owner, msg.value);
            users[msg.sender].escrow[_token] -= msg.value;
            _job.paid = true;
            _job.datePaid = block.timestamp;
            setJobById(_job);
        }
    }

    function balanceOf(
        address _address,
        address _token
    ) external view returns (uint256) {
        return users[_address].escrow[_token];
    }

    receive() external payable {
        users[msg.sender].escrow[vars.bnbToken] += msg.value;
    }
}


// File contracts/libs/utils.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Utilities {}
