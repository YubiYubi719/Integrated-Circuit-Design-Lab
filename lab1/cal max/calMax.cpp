#include <bits/stdc++.h>
using namespace std;

int main(){
    int W_max = 7;
    int VGS_max = 7;
    int VDS_max = 7;

    int max_triode_ID = INT_MIN;
    int max_triode_gm = INT_MIN;
    int max_sat_ID = INT_MIN;
    int max_sat_gm = INT_MIN;

    ofstream output("nonAppearNum.txt");
    vector<bool> times(253,false);


    for(int curW = 1; curW <= W_max; curW++){
        for(int cur_VGS = 1; cur_VGS <= VGS_max; cur_VGS++){
            for(int cur_VDS = 1; cur_VDS <= VDS_max; cur_VDS++){
                int cur_triode_ID = curW * (2*(cur_VGS-1)*cur_VDS - cur_VDS*cur_VDS);
                int cur_triode_gm = 2 * curW * cur_VDS;
                int cur_sat_ID = (curW * (cur_VGS-1) * (cur_VGS-1));
                int cur_sat_gm = 2 * curW * (cur_VGS-1);

                if(cur_triode_ID >= 0) times[cur_triode_ID] = true;
                if(cur_triode_gm >= 0) times[cur_triode_gm] = true;
                if(cur_sat_ID >= 0) times[cur_sat_ID] = true;
                if(cur_sat_gm >= 0) times[cur_sat_gm] = true;

                // max_triode_ID = (cur_triode_ID > max_triode_ID)? cur_triode_ID:max_triode_ID;
                // max_triode_gm = (cur_triode_gm > max_triode_gm)? cur_triode_gm:max_triode_gm;
                // max_sat_ID = (cur_sat_ID > max_sat_ID)? cur_sat_ID:max_sat_ID;
                // max_sat_gm = (cur_sat_gm > max_sat_gm)? cur_sat_gm:max_sat_gm;
            }
        }
    }
    // cout << max_triode_ID << '\n';
    // cout << max_triode_gm << '\n';
    // cout << max_sat_ID << '\n';
    // cout << max_sat_gm << '\n';
    int cnt = 0;
    for(int i = 0; i < 253; i++){
        if(times[i] == false) cnt++;
    }
    output << cnt << '\n';
    for(int i = 0; i < 253; i++){
        if(times[i] == false) output << i << '\n';
    }

    output.close();

    return 0;
}