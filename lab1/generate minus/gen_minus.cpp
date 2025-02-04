#include <bits/stdc++.h>
using namespace std;

int main(){
    ofstream output("output.txt");
    output << "case(V_GS)" << '\n';
    for(int i = 1; i <= 7; i++){
        output << "  3'd" << i << ": vgs_minus1 = 3'd" << i-1 << ";"<< '\n';
    }
    output << "endcase" << '\n';
    output.close();

    return 0;
}