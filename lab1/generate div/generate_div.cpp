#include <bits/stdc++.h>
using namespace std;

int main(){
    ifstream input("nonAppearNum.txt");
    int n;
    input >> n;
    unordered_map<int,int> m;
    for(int i = 0; i < n; i++){
        int tmp;
        input >> tmp;
        m.insert({tmp,0});
    }
    
    ofstream output("output.txt");
    output << "case(arr_tmp1[i])" << '\n';
    int idx = 0;
    for(int i = 0; i <= 255; i++){
        if(!m.count(i)){
            output << "8'd" << i << ": arr_tmp2[0] = 7'd" << i/3  << ";" << '\n';
        }
    }
    output << "endcase" << '\n';
    output.close();

    return 0;
}