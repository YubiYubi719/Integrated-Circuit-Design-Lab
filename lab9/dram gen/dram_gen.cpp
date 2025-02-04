#include <bits/stdc++.h>
using namespace std;

string dec2hex(int num){
    string hex;
    while(num > 0){
        if(num%16 >= 0 && num%16 <= 9) hex += to_string(num%16);
        else{
            switch(num%16){
                case 10: hex += "A"; break;
                case 11: hex += "B"; break;
                case 12: hex += "C"; break;
                case 13: hex += "D"; break;
                case 14: hex += "E"; break;
                case 15: hex += "F"; break;
            }
    }
        num /= 16;
    }
    reverse(hex.begin(),hex.end());
    return hex;
}

int main(){
    srand(time(NULL));
    ofstream output("dram.dat");
    for(int i = 0; i < 256; i++){
        int month = rand()%12 + 1;
        int day;
        switch(month){
            case 1: day = rand()%31 + 1; break;
            case 2: day = rand()%28 + 1; break;
            case 3: day = rand()%31 + 1; break;
            case 4: day = rand()%30 + 1; break;
            case 5: day = rand()%31 + 1; break;
            case 6: day = rand()%30 + 1; break;
            case 7: day = rand()%31 + 1; break;
            case 8: day = rand()%31 + 1; break;
            case 9: day = rand()%30 + 1; break;
            case 10: day = rand()%31 + 1; break;
            case 11: day = rand()%30 + 1; break;
            case 12: day = rand()%31 + 1; break;
        }
        
        int b_tea_num = rand() % 4096;
        int g_tea_num = rand() % 4096;
        int milk_num  = rand() % 4096;
        int ppj_num   = rand() % 4096;

        string addr1 = dec2hex(i*8);
        while(addr1.length() < 3) addr1.insert(0,"0");
        output << "@10" << addr1 << '\n';
        string milk = dec2hex(milk_num);
        while(milk.length() < 3) milk.insert(0,"0");
        string ppj = dec2hex(ppj_num);
        while(ppj.length() < 3) ppj.insert(0,"0");
        string day_str = dec2hex(day);
        while(day_str.length() < 2) day_str.insert(0,"0");
        string firstLine = milk + ppj + day_str;
        output << firstLine[6] << firstLine[7] << " "
               << firstLine[4] << firstLine[5] << " "
               << firstLine[2] << firstLine[3] << " "
               << firstLine[0] << firstLine[1] << '\n';

        string addr2 = dec2hex(i*8 + 4);
        while(addr2.length() < 3) addr2.insert(0,"0");
        output << "@10" << addr2 << '\n';
        string b_tea = dec2hex(b_tea_num);
        while(b_tea.length() < 3) b_tea.insert(0,"0");
        string g_tea = dec2hex(g_tea_num);
        while(g_tea.length() < 3) g_tea.insert(0,"0");
        string month_str = dec2hex(month);
        while(month_str.length() < 2) month_str.insert(0,"0");
        string secondLine = b_tea + g_tea + month_str;
        output << secondLine[6] << secondLine[7] << " "
               << secondLine[4] << secondLine[5] << " "
               << secondLine[2] << secondLine[3] << " "
               << secondLine[0] << secondLine[1] << '\n';
    }
    output.close();
    return 0;
}