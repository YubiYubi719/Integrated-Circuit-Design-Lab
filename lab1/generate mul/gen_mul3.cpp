#include <bits/stdc++.h>
using namespace std;

int main(){
    ofstream output("output.txt");
    for(int i = 0; i <= 127; i++){
        output << "7'd" << i << ": mul_2 = 10'd" << i*5 << ";" << '\n';
    }

    output.close();
    return 0;
}