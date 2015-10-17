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
map<int, vector<int> > actorMap;
map<int, vector<weight> > weightMap;
int n=0;
string name[6000000];
map<string, int> movie;

int ReadWrite(string path)
{

    ifstream infile;
    string line;
    infile.open(path);
    if(!infile)
        cout << "error: cannot open file" << endl;


    int id=n;

	while (getline(infile, line))
	{
        vector<string> temp;
		char *str = (char*)line.data();
		const char * split = "\t\t";
		char * p;
		p = strtok(str, split);

        name[id] = p;
		while (p != NULL) {
            temp.push_back(p);
			p = strtok(NULL, split);
			
		}
        
        for(int i=1; i<temp.size(); i++){
			filmMap[temp[i]].push_back(id);
        }

            id++;

        temp.clear();
	}
    n = id;
    infile.close();

    return 0;
}

int main(){
	ReadWrite("/Users/luanzhang/Dropbox/ucla/EE232/project_2/actor_movies.txt");
    ReadWrite("/Users/luanzhang/Dropbox/ucla/EE232/project_2/actress_movies.txt");
    
    //cerr << (filmMap.begin())->first << ":"<< (filmMap.begin())->second[1] <<endl;
    for(map<string,vector<int> >::iterator it = filmMap.begin(); it!=filmMap.end(); it++){
       // cerr << it->first << " ";
        for (int i = 0; i != (it->second).size(); i++) {
         //   cerr<< (it->second)[i] << " ";
        }
        //cerr << endl;
    }


    // generate film map
    int k=0;
    int actorNumofMovie[1000000];
    for(map<string,vector<int> >::iterator it = filmMap.begin(); it!=filmMap.end();){
        if((it->second).size()<5){  //delete movie less than 5
            it = filmMap.erase(it);
        }
        else{
            movie[it ->first] = k;//generate movie id
            actorNumofMovie[k++] = (it->second).size();
            it++;
        }
    }
    
    //generate actor map
    for(map<string,vector<int> >::iterator it = filmMap.begin(); it!=filmMap.end(); it++){
        for (int i = 0; i != (it->second).size(); i++) {
            actorMap[(it->second)[i]].push_back(movie[it->first]);
        }
    }
    
    
    
    // fill edge weight
    for(map<int,vector<int> >::iterator it = actorMap.begin(); it!=actorMap.end(); it++){
        for(int m=0; m<(it->second).size()-1;m++){
            for(int n=m+1; n<(it->second).size(); n++){
                if(m == n) continue;
                int j=(it->second)[m];
                int k=(it->second)[n];
                if(j >= k) {
                    int t;
                    t = j;
                    j = k;
                    k = t;
                }
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

//    for(map<string,vector<int> >::iterator it1 = filmMap.begin(); it1!=filmMap.end(); it1++){
//        map<string,vector<int> >::iterator it2 = it1;
//        it2++;
//        for(it2; it2!=filmMap.end(); it2++){
//            float countActor = 0;
//            for(int i=0; i<((it1->second).size()); i++){
//                for(int j=0; j<((it2->second).size()); j++){
//                    if((it1->second)[i] == (it2->second)[j]){
//                        countActor++;
//                        break;
//                    }
//                }
//            }
//            weight temp;
//            
//
//            temp.id2 = movie.find(it2->first)->second;
//            temp.w = countActor/((it1->second).size()+(it2->second).size()-countActor);
//            weightMap[(movie.find(it1->first)->second)].push_back(temp) ;
//        }
//    }
    
    
    //output to file
    ofstream outfile("/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_undirected_5.txt", ios::out);
    if (outfile.fail())
    {
        cout << "Error opening the file ";
        exit(1);
    }


    for(map<int,vector<weight> >::iterator it = weightMap.begin(); it!=weightMap.end(); it++){
        for (int i = 0; i != (it->second).size(); i++) {
            float mw;
            mw = (it->second)[i].w / (actorNumofMovie[it->first]+actorNumofMovie[(it->second)[i].id2]-(it->second[i].w));
            outfile << it->first << "\t" << (it->second)[i].id2 << "\t" << mw << endl;
        }
        
    }
    outfile.close();
}
