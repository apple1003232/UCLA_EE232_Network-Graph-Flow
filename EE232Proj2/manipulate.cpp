#include <iostream>
#include <fstream>
#include <sstream>
#include <string>  
#include <stdexcept>
#include <map>
#include <vector>
using namespace std;

typedef struct{
    int id2;
    float w;
}weight;
map<string, vector<int> > filmMap;
map<string, int> actorMap;
map<int, vector<weight> > weightMap;
int n=0;
float count0[300000];
string name[300000];

int ReadWrite(string path, string fileout)
{

    ifstream infile;
    string line;
    infile.open(path);
    if(!infile)
        cout << "error: cannot open file" << endl;


    ofstream output(fileout, ios::out | ios::app);
	if (output.fail())
	{
		cout << "Error opening the file ";
		exit(1);
	}
    vector<string> temp;
    int id=n;
    int a;
	while (getline(infile, line))
	{

		char *str = (char*)line.data();
		const char * split = "\t\t";
		char * p;
		p = strtok(str, split);
        a=id;
        name[a] = p;
	    count0[id]=0;
		while (p != NULL) {
            temp.push_back(p);
			count0[id]++;
			p = strtok(NULL, split);
			
		}
		if (count0[id] >= 6)
		{
			output << line << endl;
			for(int i=1; i<temp.size(); i++)
			filmMap[temp[i]].push_back(a);
            count0[id]--;
            id++;
		}
        temp.clear();
	}
    n = id;
    infile.close();
	output.close();
    return 0;
}

int main(){
	ReadWrite("/Users/luanzhang/Dropbox/ucla/EE232/project_2/actor_movies.txt", "/Users/luanzhang/Dropbox/ucla/EE232/project_2/merge.txt");
    ReadWrite("/Users/luanzhang/Dropbox/ucla/EE232/project_2/actress_movies.txt", "/Users/luanzhang/Dropbox/ucla/EE232/project_2/merge.txt");
    
    ofstream outid("/Users/luanzhang/Dropbox/ucla/EE232/project_2/actorID.txt", ios::out);
    if (outid.fail())
    {
        cout << "Error opening the file ";
        exit(1);
    }
    for(int i=0; i<sizeof(name)/sizeof(name[0]); i++){
        outid << i << "\t" << name[i] << endl;
    }

    // fill edge weight
    for(map<string,vector<int> >::iterator it = filmMap.begin(); it!=filmMap.end(); it++){
        for(int m=0; m<(it->second).size();m++){
            for(int n=0; n<(it->second).size(); n++){
                if(m ==n) continue;
                int j=(it->second)[m];
                int k=(it->second)[n];
                map<int,vector<weight> >::iterator it2 = weightMap .find(j);
                if(it2 == weightMap.end()){//actor1 not found, create a record and initialize edge weights
                    weight temp;
                    temp.id2 = k;
                    temp.w =1;
                    weightMap[j].push_back(temp);
                }
                else{//found actor1 j
                    //search actor2 k
                    //vector<weight> component = it2->second;
                    int i;
                    for(i = 0; i!= (it2->second).size(); i++){
                        if ((it2->second)[i].id2 == k) {//found actor2 k, edge weight ++
                            (it2->second)[i].w++;
                            break;
                        }
                        
                    }
                    if (i == (it2->second).size()) {// actor2 k not found, create a record
                        weight temp;
                        temp.id2 = k;
                        temp.w =1;
                        weightMap[j].push_back(temp);
                    }
                }
            }
        }
    }
    //output to file
    ofstream outfile("/Users/luanzhang/Dropbox/ucla/EE232/project_2/result.txt", ios::out);
    if (outfile.fail())
    {
        cout << "Error opening the file ";
        exit(1);
    }


    for(map<int,vector<weight> >::iterator it = weightMap.begin(); it!=weightMap.end(); it++){
        for (int i = 0; i != (it->second).size(); i++) {
            outfile << it->first << "\t" << (it->second)[i].id2 << "\t" << (it->second)[i].w/count0[it->first] << endl;
        }
        
    }
    outfile.close();
}
