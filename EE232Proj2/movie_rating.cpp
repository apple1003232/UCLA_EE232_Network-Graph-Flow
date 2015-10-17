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
int n=0;
string name[6000000];
float movieRating[1500000];
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
    
    // generate film map
    int k=0;
    int j=0;

    for(map<string,vector<int> >::iterator it = filmMap.begin(); it!=filmMap.end();){
//        if((it->second).size()<15 && (it->first)!=movie1 && (it->first)!=movie2 && (it->first)!=movie3){  //delete movie less than 5
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
    genrefile.open("/Users/luanzhang/Dropbox/ucla/EE232/project_2/movie_rating.txt");
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
            p = strtok(NULL, split);  //movie rating
            movieRating[genreID] = atof(p);
            
        }
        
    }
    genrefile.close();

	    ifstream community;
    map<int, vector<string> > tag;//communityID -> vector<genres>
    map<string, int> countTag;// genre -> #of genre within a community, NOTICE:need to be cleared once read
    community.open("/Users/luanzhang/Dropbox/ucla_new/EE232/project_2/result/7/6.txt");
    if(!community)
        cout << "error: cannot open file" << endl;
    int communityID;
    int countRead = 0;
    float ratingNeighbor=0;
    float ratingCom=0;
    int nCom=0;
    int nNb = 0;
    float rating;
    while (getline(community, line))
    {
        
        if(line == "community"){
            while(getline(community, line)){
                char *str = (char*)line.data();
                if( movieRating[atoi(str)] !=0){
                    ratingCom = ratingCom + movieRating[atoi(str)];
                    nCom++;
                   // cout << nCom << "rating: " <<movieRating[atoi(str)] <<endl;
                }
            }
            break;
        }
        else{
            char *str = (char*)line.data();
            if( movieRating[atoi(str)] !=0){
                ratingNeighbor = ratingNeighbor + movieRating[atoi(str)];
                nNb++;
            }
          //  cout << "neighbor rating : " << movieRating[atoi(str)] <<endl;
        }
        

    }
    cout <<endl;
    cout << "average rating of neighbors: " << ratingNeighbor/nNb <<endl;
    cout << "number of neighbors: " << nNb <<endl;
    cout << "average rating of communities: " << ratingCom/nCom <<endl;
    cout << "number of communities: " << nCom <<endl;

	
return 0;
}
