#include <bits/stdc++.h>
using namespace std;

int main(){
    ofstream output("output_tmp2.txt");

    output << "case(tmp1)" << '\n';
    for(int i = 0; i <= 63; i++){
        if(i == 0){
            output << "  6'd0" <<  ": tmp2 = 0" << ";" << '\n';
            continue;
        }
        output << "  6'd" << i << ": begin" << '\n';
        output << "    case(W)" << '\n';
        for(int j = 0; j <= 7; j++){
            output << "      3'd" << j << ": tmp2 = " << i*j << ";" << '\n';
        }
        output << "    endcase" << '\n';
        output << "  end" << '\n';
    }
    output << "endcase" << '\n';

    output.close();

    return 0;
}