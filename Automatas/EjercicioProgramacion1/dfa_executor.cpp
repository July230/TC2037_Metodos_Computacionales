#include <iostream>

using namespace std;
			   // dig, +/-,  . , del, otro
int MT[5][5] = {{   1,   2,   3, 200, 200},
				{   1, 200,   3, 101, 200},
				{   1, 200,   3, 200, 200},
				{   4, 200, 200, 200, 200},
				{   4, 200, 200, 100, 200}};

int convert(char c) {
	switch(c) {
		case '0' :
		case '1' :
		case '2' :
		case '3' :
		case '4' :
		case '5' :
		case '6' :
		case '7' :
		case '8' :
		case '9' : return 0;
		case '+' :
		case '-' : return 1;
		case '.' : return 2;
		case ' ' :
		case '\0': return 3;
		default  : return 4;
	}
}

int main(int argc, char* argv[]) {
	char c, input[80];
	int i, state;
	int res;

	cout << "Cuantos numeros quieres evaluar?: ";
	cin >> res;

	for(int j = 0; j < res; j++){
	cout << "Expresion to evaluate: ";
	cin >> input;

	i = 0;
	state = 0;
	while (state < 100) {
		c = input[i++];
		state = MT[state][convert(c)]; // Asociar un 100 para float y 101 para integer
		if (state == 100) {
			cout << "Accepted Float\n";
		} else if (state == 101){
			cout << "Accepted Integer\n";
		} else if (state == 200){
			cout << "ERROR\n";
		}
	}
	}
	cout << "End Of Analysis\n";
	return 0;
}