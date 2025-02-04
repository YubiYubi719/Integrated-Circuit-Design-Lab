#include <bits/stdc++.h>
using namespace std;

int main(){
    ifstream input("dram.dat");
    for(int i = 0; i < 256; i++){
        string tmp;
        vector<int> curLine;
        input >> tmp; // ignore addr
        for(int i = 0; i < 4; i++){
            input >> tmp;
            if(tmp[0] >= 65 && tmp[0] <= 70) curLine.push_back(tmp[0]-55);
            else curLine.push_back(tmp[0]-48);

            if(tmp[1] >= 65 && tmp[1] <= 70) curLine.push_back(tmp[1]-55);
            else curLine.push_back(tmp[1]-48);
        }
        int milk = 256*curLine[6] + 16*curLine[7] + curLine[4];
        int ppj  = 256*curLine[5] + 16*curLine[2] + curLine[3];
        int day = 16*curLine[0] + curLine[1];
        
        input >> tmp; // ignore addr
        curLine.clear();
        for(int i = 0; i < 4; i++){
            input >> tmp;
            if(tmp[0] >= 65 && tmp[0] <= 70) curLine.push_back(tmp[0]-55);
            else curLine.push_back(tmp[0]-48);

            if(tmp[1] >= 65 && tmp[1] <= 70) curLine.push_back(tmp[1]-55);
            else curLine.push_back(tmp[1]-48);
        }
        int b_tea = 256*curLine[6] + 16*curLine[7] + curLine[4];
        int g_tea  = 256*curLine[5] + 16*curLine[2] + curLine[3];
        int month = 16*curLine[0] + curLine[1];
        if(!(b_tea >= 0 && b_tea <= 4095)
        || !(g_tea >= 0 && g_tea <= 4095)
        || !(milk >= 0 && milk <= 4095)
        || !(ppj >= 0 && ppj <= 4095)){
            cout << "drink num error" << '\n';
            break;
        }
        if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
            if(!(day >= 1 && day <= 31)){
                cout << "date error" << '\n';
                break;
            }
        }
        else if(month == 4 || month == 6 || month == 9 || month == 11){
            if(!(day >= 1 && day <= 30)){
                cout << "date error" << '\n';
                break;
            }
        }
        else if(month == 2){
            if(!(day >= 1 && day <= 28)){
                cout << "date error" << '\n';
                break;
            }
        }
    }

    return 0;
}