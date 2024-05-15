#pragma once
#include <iostream>
using namespace std;
#include <fstream>
#include <bitset>
#include <string>
#include <sstream>

//Get address of required register
string GetAddress(int RegNum)
{
	if (RegNum == 0)
		return "000";
	else if (RegNum == 1)
		return "001";
	else if (RegNum == 2)
		return "010";
	else if (RegNum == 3)
		return "011";
	else if (RegNum == 4)
		return "100";
	else if (RegNum == 5)
		return "101";
	else if (RegNum == 6)
		return "110";
	else if (RegNum == 7)
		return "111";
}

//Convert immediate (hex) number to 16-bit binary 
string HexToBinary(const string& hex_input) 
{
	string binary_output = ""; 
	for (char c : hex_input) 
	{
		int hex_value;
		stringstream ss;
		ss << hex << c; // Convert character to hexadecimal number
		ss >> hex_value;
		bitset<4> binary(hex_value); // Convert hexadecimal value to 4-bit binary number

		//Connect the binary number to the output string
		binary_output += binary.to_string();
	}

	//If the binary number is less than 16 bits, add zeros
	if (binary_output.size() < 16) 
	{
		binary_output = string(16 - binary_output.size(), '0') + binary_output;
	}

	return binary_output;
}



int main()
{
	ifstream inFile("input.txt"); //open file to read from

	if (!inFile.is_open()) {
		cerr << "Error opening the file." << endl;
		return 1;
	}

	ofstream myfile;
	myfile.open("output.mem"); //MEM file to write in

	string instruction,imm, binary, commentedline;
	char r;
	int Reg1,Reg2,Reg3;
	int index = 0;
	int previndex = 0;
	myfile << "// memory data file (do not edit the following line - required for mem load use)\n";
	myfile << "// instance=/processor/fetch1/icache/ram\n";
	myfile << "// format=mti addressradix=h dataradix=s version=1.0 wordsperline=4\n";
	while (1)
	{
		inFile >> instruction;
		if (inFile.eof()) //To end the infinite loop
			break;

		//Ignore any comments//
		if (instruction == "#")
		{
			getline(inFile, commentedline);
		}
		if (instruction == ".ORG") {
			inFile >> index;
			if (previndex <= index) {
				for (int i = previndex; i < index; i++) {
					myfile << i << ": ";
					myfile << "0000000000000000\n";
				}
			}

		}
		//Make all letters upper case for the 'if condition' to apply correctly//
		for (char& c : instruction) 
		{
			c = toupper(c);
		}
		
		if (instruction == "NOP")
		{
			myfile << index << ": ";
			myfile << "0000000000000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "NOT")
		{
			myfile << index << ": ";
			myfile << "00001";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1)<<"00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "NEG")
		{
			myfile << index << ": ";
			myfile << "00010";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "INC")
		{
			myfile << index << ": ";
			myfile << "00011";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "DEC")
		{
			myfile << index << ": ";
			myfile << "00100";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "OUT")
		{
			myfile << index << ": ";
			myfile << "00101";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "IN")
		{
			myfile << index << ": ";
			myfile << "00110";
			inFile >> r >> Reg1;
			myfile << "000000" << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "MOV")
		{
			myfile << index << ": ";
			myfile << "00111";
			inFile >> r >> Reg1 >> r >> r >> Reg2;
			myfile << GetAddress(Reg2) << "000" << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "SWAP")
		{
			myfile << index << ": ";
			myfile << "01000";
			inFile >> r >> Reg1 >> r >> r >> Reg2;
			myfile << GetAddress(Reg2) << GetAddress(Reg1) << "00000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction=="ADD")
		{
			myfile << index << ": ";
			myfile << "01001";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> r >> Reg3;
			myfile << GetAddress(Reg2) << GetAddress(Reg3) << GetAddress(Reg1)<<"00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "ADDI")
		{
			myfile << index << ": ";
			myfile << "01010";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> imm;
			myfile << GetAddress(Reg2) << "000" << GetAddress(Reg1) << "01\n";
			int neg = 0;

			//Check if immediate value is negative and act accordingly
			if (imm[0] == '-')
			{
				neg = 1;
				imm = imm.substr(1); //remove the '-' sign
			}
			binary=HexToBinary(imm);
			if (neg == 1)
			{
				binary.replace(0, 1, "1"); //sign bit
			}
			index++;
			myfile << index << ": ";
			myfile << binary << "\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "SUB")
		{
			myfile << index << ": ";
			myfile << "01011";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> r >> Reg3;
			myfile << GetAddress(Reg2) << GetAddress(Reg3) << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "SUBI")
		{
			myfile << index << ": ";
			myfile << "01100";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> imm;
			myfile << GetAddress(Reg2) << "000" << GetAddress(Reg1) << "01\n";
			int neg = 0;
			//Check if immediate value is negative and act accordingly
			if (imm[0] == '-')
			{
				neg = 1;
				imm = imm.substr(1); //remove the '-' sign
			}
			binary = HexToBinary(imm);
			if (neg == 1)
			{
				binary.replace(0, 1, "1"); //sign bit
			}
			index++;
			myfile << index << ": ";
			myfile << binary << "\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "AND")
		{
			myfile << index << ": ";
			myfile << "01101";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> r >> Reg3;
			myfile << GetAddress(Reg2) << GetAddress(Reg3) << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "OR")
		{
			myfile << index << ": ";
			myfile << "01110";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> r >> Reg3;
			myfile << GetAddress(Reg2) << GetAddress(Reg3) << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "XOR")
		{
			myfile << index << ": ";
			myfile << "01111";
			inFile >> r >> Reg1 >> r >> r >> Reg2 >> r >> r >> Reg3;
			myfile << GetAddress(Reg2) << GetAddress(Reg3) << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "CMP")
		{
			myfile << index << ": ";
			myfile << "10000";
			inFile >> r >> Reg1 >> r >> r >> Reg2;
			myfile << GetAddress(Reg1) << GetAddress(Reg2) << "00000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "PUSH")
		{
			myfile << index << ": ";
			myfile << "10001";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "POP")
		{
			myfile << index << ": ";
			myfile << "10010";
			inFile >> r >> Reg1;
			myfile << "000000" << GetAddress(Reg1) << "00\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "LDM")
		{
			myfile << index << ": ";
			myfile << "10011";
			inFile >> r >> Reg1 >> r >> imm;
			myfile << "000000" << GetAddress(Reg1) << "01\n";
			int neg = 0;
			//Check if immediate value is negative and act accordingly
			if (imm[0] == '-')
			{
				neg = 1;
				imm = imm.substr(1); //remove the '-' sign
			}
			binary = HexToBinary(imm);
			if (neg == 1)
			{
				binary.replace(0, 1, "1"); //sign bit
			}
			index++;
			myfile << index << ": ";
			myfile << binary << "\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "LDD")
		{
			myfile << index << ": ";
			myfile << "10100";
			inFile >> r >> Reg1 >> r;

			//Read EA Before '('
			char imm1;
			inFile >> imm1;
		    imm = string(1, imm1);
	     	char imm2;
		    inFile >> imm2;
		    while (imm2 != '(')
		{
			imm = imm + string(1, imm2);
			inFile >> imm2; //last iteration will read the '('
		}
			

			//Check if the EA is negative
			int neg = 0;
			if (imm1 == '-')
			{
				neg = 1;
				imm = imm.substr(1); //remove the '-' sign
			}
			inFile >> r >> Reg2 >> r;
			myfile << "000"<<GetAddress(Reg2)<<GetAddress(Reg1)<<"01\n";
			binary = HexToBinary(imm);
			if (neg == 1)
			{
				binary.replace(0, 1, "1"); //sign bit
			}
			index++;
			myfile << index << ": ";
			myfile << binary << "\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "STD")
		{
			myfile << index << ": ";
			myfile << "10101";
			inFile >> r >> Reg1 >> r;

			//Read EA before '('
			char imm1;
			inFile >> imm1;
			imm = string(1, imm1);
			char imm2;
			inFile >> imm2;
			while (imm2 != '(')
			{
				imm = imm + string(1, imm2);
				inFile >> imm2; //last iteration will read the '('
			}

			//Check if EA is negative
			int neg = 0;
			if (imm1 == '-')
			{
				neg = 1;
				imm = imm.substr(1); //remove the '-' sign
			}
			inFile >> r >> Reg2 >> r;
			myfile << GetAddress(Reg1) << GetAddress(Reg2) << "00001\n";
			binary = HexToBinary(imm);
			if (neg == 1)
			{
				binary.replace(0, 1, "1"); //sign bit
			}
			index++;
			myfile << index << ": ";
			myfile << binary << "\n"; 
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "PROTECT")
		{
			myfile << index << ": ";
			myfile << "10110";
			inFile >> r >> Reg1;
			myfile << "000" << GetAddress(Reg1) << "00000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "FREE")
		{
			myfile << index << ": ";
			myfile << "10111";
			inFile >> r >> Reg1;
			myfile << "000" << GetAddress(Reg1) << "00000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "JZ")
		{
			myfile << index << ": ";
			myfile << "11000";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "JMP")
		{
			myfile << index << ": ";
			myfile << "11001";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "00000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "CALL")
		{
			myfile << index << ": ";
			myfile << "11010";
			inFile >> r >> Reg1;
			myfile << GetAddress(Reg1) << "000000000\n";
			index++;
			previndex = index;

			continue;
		}
		if (instruction == "RET")
		{
			myfile << index << ": ";
			myfile << "1101100000000000\n";
			index++;
			previndex = index;
			continue;
		}
		if (instruction == "RTI")
		{
			myfile << index << ": ";
			myfile << "1110000000000000\n";
			index++;
			previndex = index;
			continue;
		}
	}
	myfile.close();
	return 0;
}