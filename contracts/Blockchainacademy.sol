pragma solidity ^0.8.0;

contract BlockchainAcademy {
    struct Module {
        uint id;
        string title;
        string content;
        string prerequisites;
        address instructor;
        bool completed; 
    }

    struct Student {
        uint id;
        string name;
        uint[] completedModules;
    }

    Module[] public modules;
    Student[] public students;

    uint public moduleCount;
    uint public studentCount;

    // Function to create a new module
    function createModule(string memory _title, string memory _content, string memory _prerequisites) public {
        moduleCount++;
        modules.push(Module(moduleCount, _title, _content, _prerequisites, msg.sender, false));
    }

    // Function to enroll a student
    function enrollStudent(string memory _name) public {
        studentCount++;
        students.push(Student(studentCount, _name, []));
    }

    // Function to complete a module
    function completeModule(uint _moduleId) public {
        require(modules[_moduleId].completed == false, "Module is already completed.");
        require(isModuleEligible(msg.sender, _moduleId), "Student is not eligible to complete this module.");

        // Verify completion (e.g., check for submitted assignments)

        modules[_moduleId].completed = true;
        students[getStudentIndex(msg.sender)].completedModules.push(_moduleId);

        // Distribute reward (e.g., mint a token)
    }

    // Helper functions
    function isModuleEligible(address _student, uint _moduleId) internal view returns (bool) {
        // Check if student has completed prerequisites
        for (uint i = 0; i < modules[_moduleId].prerequisites.length; i++) {
            if (!isModuleCompleted(_student, bytes(modules[_moduleId].prerequisites)[i])) {
                return false;
            }
        }
        return true;
    }

    function isModuleCompleted(address _student, uint _moduleId) internal view returns (bool) {
        for (uint i = 0; i < students[getStudentIndex(_student)].completedModules.length; i++) {
            if (students[getStudentIndex(_student)].completedModules[i] == _moduleId) {
                return true;
            }
        }
        return false;
    }

    function getStudentIndex(address _student) internal view returns (uint) {
        for (uint i = 0; i < students.length; i++) {
            if (students[i].id == _student) {
                return i;
            }
        }
        revert("Student not found.");
    }
}

