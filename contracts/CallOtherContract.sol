// LICENSE

pragma solidity ^0.8.0;

contract Greeter {
    function sayHello() public view returns (string memory) {
        return "hola";
    }

    function sayGoodbye() public view returns (string memory) {
        return "adios";
    }
}

contract Counter {
    uint count = 0;

    function increment() external {
        count + 1;
    }
}

interface IGreeter {
    function sayHello() external view returns (string memory);
}

// CALLER HEREDA DE COUNTER -> ES DECIR HACE COPY PASTE DE SU CÓDIGO
// Y puede acceder a sus varaibles y funciones, salvo variables privadas

// La interfaz permite conocer a Caller el comportamiento de Greeter
// pero no implementa esa logica
contract Caller is Counter {
    function readCount() public view returns (uint) {
        return count;
    }

    function callA(IGreeter greeterContract) external {
        greeterContract.sayHello();
    }
}
