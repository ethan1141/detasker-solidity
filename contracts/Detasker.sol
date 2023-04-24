// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
/**
 * @title Detasker - a simple smart contract to facilitate users in web3 anouncing jobs and/or skills
 * @author Ethan Russell <ethanrussell.dev>
 * @notice
 */
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

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
        string[] documents; // with greenfield
        address owner;
        address requester;
        uint256 postedDate;
        uint256 date;
        uint256 datePaid;
        string img; // with greenfield
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
        Rating[] rating;
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
            users[_address].freeLanceId == 0,
            "Please go through the update method. "
        );
        uint256 id = vars.freelance.length + 1;
        freelance.id = id;
        vars.freelance.push(freelance);
        users[_address].freeLanceId = id;
    }

    function createUser(address _address, NewProfile memory _profile) public {
        vars.userCount += 1;
        uint256 id = vars.userCount;
        users[_address].id = id;
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
        uint id = vars.skills.length + 1;
        Profile storage p = users[_address];
        _skill.id = id;
        _skill.profileId = p.id;
        _skill.user = _address;
        vars.freelance[p.freeLanceId - 1].skillsId.push(id);
        vars.skills.push(_skill);
        vars.skillCount = id;
    }

    function createSocial(address _address, Social memory _social) public {
        users[_address].socials.push(_social);
    }

    function getJobCount() external view returns (uint256) {
        return vars.jobs.length;
    }

    function getSkillCount() external view returns (uint256) {
        return vars.skills.length;
    }

    function getSkill(uint256 i) external view returns (Skill memory) {
        return vars.skills[i];
    }

    function createJob(address _address, Job memory _job) public {
        uint256 index = vars.jobs.length + 1;
        _job.profileId = users[_address].id;
        _job.id = index;
        _job.owner = _address;
        _job.hasFunds = false;
        _job.completed = false;
        _job.paid = false;
        _job.assigned = false;
        _job.deleted = false;
        users[_address].jobsId.push(index);
        vars.jobs.push(_job);
    }

    function completeJob(uint256 _jobId) external payable {
        Job memory _job = getJobById(_jobId);
        require(
            _job.requester ==
                address(0x81e70AAF7475AabA6D919e3A889b6D94C792c8A3),
            "Sorry, your not allowed to withdraw funds. Only the job requester is allowed"
        );
        // require(
        //     IERC20(_job.token).allowance(address(this), address(this)) <
        //         msg.value,
        //     "Amount approved is less then token transferred amount"
        // );

        if (msg.value >= _job.requestedPaymentAmount) {
            // IERC20(_job.token).transferFrom(
            //     address(this),
            //     address(0x81e70AAF7475AabA6D919e3A889b6D94C792c8A3),
            //     msg.value
            // );
            // users[address(0x81e70AAF7475AabA6D919e3A889b6D94C792c8A3)].escrow[
            //         _job.token
            //     ] -= msg.value;
            _job.paid = true;
            _job.completed = true;
            _job.datePaid = block.timestamp;
            setJobById(_job);
        }
        emit CompletingJob(
            _job.owner,
            _job.requester,
            _job.requestedPaymentAmount,
            true
        );
    }

    function giveFeedback(address _address, Rating memory _rating) public {
        Job memory _job = getJobById(_rating.jobId - 1);
        require(_job.owner == _address, "This isn't your assigned job");
        require(
            _rating.rating >= 0 && _rating.rating <= 5,
            "Please give this job a rating out of 5"
        );

        uint256 id = vars.ratings.length + 1;
        _rating.id = id;
        users[_job.requester].rating.push(_rating);
    }

    function getRatingsArray(
        address _address
    ) external view returns (Rating[] memory) {
        return users[_address].rating;
    }

    // function dispueAJob(string calldata _reason, uint256 _jobId) external {
    //     Job memory _job = getJobById(_jobId);
    //     _job.dispute[_job.dispute.length] = Dispute(_reason, block.timestamp);
    //     _job.completed = false;
    //     setJobById(_job);
    // }

    function assignJob(address _address, uint256 jobId) public {
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
        vars.jobs[_job.id - 1] = _job;
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
