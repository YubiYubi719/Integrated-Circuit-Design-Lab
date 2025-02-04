#include <bits/stdc++.h>
using namespace std;

int main(){
    ofstream output("output.txt");

    output << "case(V_DS)" << '\n';
    for(int i = 0; i <= 7; i++){
        if(i == 0){
            output << "  3'd0" <<  ": tmp1 = 0" << ";" << '\n';
            continue;
        }
        output << "  3'd" << i << ": begin" << '\n';
        output << "    case(temp)" << '\n';
        for(int j = 0; j <= 15; j++){
            output << "      4'd" << j << ": tmp1 = " << i*j << ";" << '\n';
        }
        output << "    endcase" << '\n';
        output << "  end" << '\n';
    }
    output << "endcase" << '\n';

    output.close();

    return 0;
}