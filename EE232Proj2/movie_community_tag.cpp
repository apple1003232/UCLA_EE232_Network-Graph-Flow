#include <iostream>
#include <fstream>
#include <sstream>
#include <string>  
#include <stdexcept>
#include <map>
#include <vector>
#include <cstdlib>
using namespace std;

typedef struct{
    int id2;
    float w;
}weight;
map<string, vector<int> > filmMap;
//map<int, vector<int> > actorMap;
//map<int, vector<weight> > weightMap;
int n=0;
string name[6000000];
string movieGenre[1500000]={"null"};
map<string, int> movie;
string insertActor[10];

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

//    string movie1, movie2, movie3;
//    movie1 = "Batman v Superman: Dawn of Justice (2016)  ";
//    movie2 = "Mission: Impossible - Rogue Nation (2015)";
//    movie3 = "Minions (2015)  ";
    
    for(int i=0;i<1500000;i++){
        movieGenre[i] = "null";
    }
    
    // generate film map
    int k=0;
    int j=0;

    for(map<string,vector<int> >::iterator it = filmMap.begin(); it!=filmMap.end();){
//        if((it->second).size()<25 && (it->first)!=movie1 && (it->first)!=movie2 && (it->first)!=movie3){  //delete movie less than 5
//            it = filmMap.erase(it);
//        }
//        else if((it->first)==movie1 || (it->first)==movie2 || (it->first)==movie3){
//            insertActor[j] = it->first;
//            it++;
//        }
//        else{
//            movie[it ->first] = k++;//generate movie id
//            it++;
//        }
        
        if((it->second).size()<15 ){  //delete movie less than 5
            it = filmMap.erase(it);
        }
        else{
            movie[it ->first] = k++;//generate movie id
            it++;
        }
    }
    
    //Insert movie
//    for(int i = 0; i<3; i++){
//        movie[insertActor[i]] = k;
//    }
    
	
    ifstream genrefile;
    string line;
    genrefile.open("/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_genre.txt");
    if(!genrefile)
        cout << "error: cannot open file" << endl;
    while (getline(genrefile, line))
    {
        
        //vector<string> temp;
        char *str = (char*)line.data();
        const char * split = "\t\t";
        char * p;
        int genreID;
        p = strtok(str, split);  //movie name
            //find movie ID
        map<string,int >::iterator it = movie.find(p);
        if(it == movie.end()) {continue;}
        if(it != movie.end()){
            genreID = it->second;
            
           // while (p != NULL) {
                //  temp.push_back(p);
                p = strtok(NULL, split);  //movie genre
                movieGenre[genreID] = p;
            //}
        }
        
    }
    genrefile.close();

	    ifstream community;
    map<int, vector<string> > tag;//communityID -> vector<genres>
    map<string, int> countTag;// genre -> #of genre within a community, NOTICE:need to be cleared once read
    community.open("/Users/luanzhang/Dropbox/ucla/EE232/project_2/result/5/movie_community_15.txt");
    if(!community)
        cout << "error: cannot open file" << endl;
    int communityID;
    int countRead = 0;
    while (getline(community, line))
    {
        char *st = (char*)line.data();
        
        if(!strncmp(st, "start", 5)){
            //before searching next community, tag the current community and clear countRead
            for(map<string, int> ::iterator it = countTag.begin(); it != countTag.end();){
                if (it->second >= countRead*0.2) {
                    tag[communityID].push_back(it->first);
                }
                it = countTag.erase(it);
            }
            countRead = 0;
            
            
            // read communityID from the first line
            getline(community, line);
            char *str = (char*)line.data();
            communityID = atoi(str);
            continue;
        }
        
        
        char *str = (char*)line.data();
        int memID = atoi(str);
        string g;
        g = movieGenre[memID-1];
        if(g!="null"){
            countRead++;
            map<string, int >::iterator it = countTag.find(g);
            if (it == countTag.end()) {
                // if the genre of memID does not exist, create one
                countTag[movieGenre[memID-1]] = 1;//in Rstudio, nodeID plus 1, thus we derease one here
            }
            else{
                // genre of memID exists, +1
                countTag[movieGenre[memID-1]] ++;
            }
        }


    }
    community.close();

    
    //output to file
    ofstream outfile("/Users/luanzhang/Dropbox/ucla/EE232/project_2/result/5/tag_result_1.txt", ios::out);
    if (outfile.fail())
    {
        cout << "Error opening the file ";
        exit(1);
    }
    for (map<int, vector<string> >::iterator it = tag.begin(); it != tag.end(); it++) {
        outfile << it->first << "\t";//community ID
        for (vector<string>::iterator ite = (it->second).begin(); ite != (it->second).end(); ite++) {
            outfile << *ite << "\t";//genre
        }
        outfile << endl;
    }

    outfile.close();
	
return 0;
}
