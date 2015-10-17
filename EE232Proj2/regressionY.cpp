#include <iostream>
#include <fstream>
#include <sstream>
#include <string>  
#include <stdexcept>
#include <map>
#include <vector>
#include <cstdlib>
#include   <algorithm> 
using namespace std;


map<string, vector<int> > filmMap;

string dname[400000];
map<string, int> movie;


int ReadWrite(string path)
{
    ifstream infile;
    string line;
    infile.open(path);
    if(!infile)
        cout << "error: cannot open file" << endl;


	int id = 0;//actor id

	while (getline(infile, line))
	{
		vector<string> temp;
		char *str = (char*)line.data();
		const char * split = "\t\t";
		char * p;
		p = strtok(str, split);

		//name[id] = p;
		while (p != NULL) {
			temp.push_back(p);
			p = strtok(NULL, split);

		}

		for (int i = 1; i<temp.size(); i++){
			filmMap[temp[i]].push_back(id);
		}

		id++;

		temp.clear();
	}

    infile.close();

	int k = 0;
	for (map<string, vector<int> >::iterator it = filmMap.begin(); it != filmMap.end(); it++){
		movie[it->first] = k++;//generate movie id, string->id
	}

    return k;
}


void getRating(string path, map<int, float> &m){
	ifstream infile;
	string line;
	infile.open(path);
	if (!infile)
		cout << "error: cannot open file" << endl;
	//read movie rating to map
	while (getline(infile, line))
	{
		char *str = (char*)line.data();
		const char * split = "\t\t";
		char * p;
		p = strtok(str, split);// movie name
		if (p == NULL)
			break;
		string n = p;

		p = strtok(NULL, split);
		float r = atof(p);// rating

		int mid;
		map<string, int> ::iterator ie = movie.find(n);
		if (ie != movie.end()){
			mid = movie[n];
			m[mid] = r;
		}
	}


	infile.close();

	return ;

}



int main(){
	int n1 = ReadWrite("D://Rtemp/actor_movies.txt");//get a map from movie to actors->filmMap
	int n2 = ReadWrite("D://Rtemp/actress_movies.txt");
    //ReadWrite("/Users/luanzhang/Dropbox/ucla/EE232/project_2/actress_movies.txt");


	map<int, float> m;
	getRating("D://Rtemp/movieRatingSample.txt", m);


	cout << "ReadWrite Successfully! " << endl;

	ofstream outfile("D://Rtemp/ratingData.txt", ios::out | ios::app);

	if (outfile.fail())
	{
		cout << "Error opening the file ratingData.txt";
		exit(1);
	}

	
    
	//generate a big matrix 106 attributes
	for (int i = 0; i != (n1+n2); i++){
		map<int, float>::iterator it = m.find(i);
		if(it != m.end())
			outfile << it->second << endl;		
		else
			outfile << 0 << endl;

	}

	outfile.close();
	
	return 0;
}
