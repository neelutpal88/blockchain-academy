// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenizedStudentLoans {
    // Struct to represent a loan
    struct Loan {
        address borrower;
        uint256 principal;  // Amount borrowed
        uint256 amountRepaid;  // Amount repaid so far
        uint256 interestRate;  // Interest rate (in basis points, e.g., 500 = 5%)
        uint256 dueDate;  // Repayment due date
        bool isActive;  // Loan status
    }

    // Mapping to store loans by ID
    mapping(uint256 => Loan) public loans;
    uint256 public nextLoanId;

    // Event emitted when a loan is issued
    event LoanIssued(uint256 loanId, address borrower, uint256 amount, uint256 interestRate, uint256 dueDate);

    // Event emitted when a repayment is made
    event RepaymentMade(uint256 loanId, address borrower, uint256 amountRepaid);

    // Event emitted when a loan is fully repaid
    event LoanRepaid(uint256 loanId, address borrower);

    // Function to issue a new loan
    function issueLoan(address _borrower, uint256 _principal, uint256 _interestRate, uint256 _dueDate) external {
        require(_principal > 0, "Principal must be greater than zero");
        require(_dueDate > block.timestamp, "Due date must be in the future");

        // Create and store the new loan
        loans[nextLoanId] = Loan({
            borrower: _borrower,
            principal: _principal,
            amountRepaid: 0,
            interestRate: _interestRate,
            dueDate: _dueDate,
            isActive: true
        });

        emit LoanIssued(nextLoanId, _borrower, _principal, _interestRate, _dueDate);
        nextLoanId++;
    }

    // Function to make a repayment
    function makeRepayment(uint256 _loanId, uint256 _amount) external {
        Loan storage loan = loans[_loanId];
        
        require(loan.isActive, "Loan is not active");
        require(loan.borrower == msg.sender, "Only the borrower can make repayments");
        require(block.timestamp < loan.dueDate, "Loan repayment period has expired");
        require(_amount > 0, "Repayment amount must be greater than zero");

        uint256 amountDue = loan.principal - loan.amountRepaid;
        require(_amount <= amountDue, "Repayment amount exceeds outstanding balance");

        loan.amountRepaid += _amount;
        
        if (loan.amountRepaid >= loan.principal) {
            loan.isActive = false;
            emit LoanRepaid(_loanId, loan.borrower);
        }

        emit RepaymentMade(_loanId, loan.borrower, _amount);
    }

    // Function to get loan details
    function getLoanDetails(uint256 _loanId) external view returns (
        address borrower,
        uint256 principal,
        uint256 amountRepaid,
        uint256 interestRate,
        uint256 dueDate,
        bool isActive
    ) {
        Loan storage loan = loans[_loanId];
        return (
            loan.borrower,
            loan.principal,
            loan.amountRepaid,
            loan.interestRate,
            loan.dueDate,
            loan.isActive
        );
    }
}

       

   
