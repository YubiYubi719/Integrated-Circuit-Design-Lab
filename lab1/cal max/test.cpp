#include <bits/stdc++.h>
using namespace std;

int main(){
    unordered_map<int,int> m;
    for(int i = 0; i <= 6; i++){
        for(int j = 0; j <= 7; j++){
            int curNum = i*2 - j;
            if(curNum >= 0){
                m.insert({curNum,0});
            }
        }
    }

    for(int i = 0; i <= 15; i++){
        if(!m.count(i)) cout << i << '\n';
    }

    return 0;
}