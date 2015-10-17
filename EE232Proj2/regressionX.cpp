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

typedef struct{
    int id2;
    float w;
}weight;
map<string, vector<int> > filmMap;
map<string, vector<int> > f2dMap;
map<int, vector<int> > d2fMap;

//string name[300000];
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

    return 0;
}

int ReadWriteDirector(string path)
{
	ifstream infile;
	string line;
	infile.open(path);
	if (!infile)
		cout << "error: cannot open file" << endl;


	int id = 0;//director id

	while (getline(infile, line))
	{
		int count = 0;
		vector<string> temp;
		char *str = (char*)line.data();
		const char * split = "\t\t";
		char * p;
		p = strtok(str, split);
		count++;

		dname[id] = p;//director id-> director name
		while (p != NULL) {
			temp.push_back(p);
			if (count != 1)//skip dir name
				d2fMap[id].push_back(movie[p]);// did->moviesid;
			p = strtok(NULL, split);
			count++;			

		}

		for (int i = 1; i<temp.size(); i++){
			f2dMap[temp[i]].push_back(id);//film->director id
		}

		id++;

		temp.clear();
	}
	

	infile.close();

	return 0;
}

void ReadInPageRank(string path, float (&id_pr)[244290]){
	ifstream infile;
	string line;
	infile.open(path);
	if (!infile)
		cout << "error: cannot open file" << endl;

	while (getline(infile, line))
	{
		char *str = (char*)line.data();
		const char * split = "\t";
		char * p;
		p = strtok(str, split);// skip 1st col

		p = strtok(NULL, split);
		int actID = atoi(p);// 2nd col -> actor id

		p = strtok(NULL, split);
		float pr = atof(p);// 3rd col -> actor's pagerank

		id_pr[actID] = pr;
	}


	infile.close();

	return ;
}

void getTop100Movies(string path, map<int, string> &m){
	map<float, string> temp;
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


		temp[r] = n;
	}

	map<float, string>::iterator it = temp.end();
	it--;
	//return top 100 movies
	for (int i = 0; i != 100; i++){
		m[i] = (it->second);
		it--;
		if (temp.size()==(i+1))
			break;
	}


	infile.close();

	return ;

}

bool comp(const float a, const float b) 
{
	return a>b;
}



void getDirector(int (&dir)[101]){
	return ;
}

void output_pr(float (&id_pr)[244290]){
	for (int i = 0; i != 100; i++)
		cout << "i:" << i << "pr:" << id_pr[i] << endl;
	return;
}

int main(){
	ReadWrite("D://Rtemp/actor_movies.txt");//get a map from movie to actors->filmMap
    ReadWrite("D://Rtemp/actress_movies.txt");

	ReadWriteDirector("D://Rtemp/director_movies.txt");//get a map from movie to diretors->f2dMap

	cout << "ReadWrite Successfully! " << endl;

	float id_pr[244290] = {};
	ReadInPageRank("D://Rtemp/PageRank.txt", id_pr);

	map<int, string> m;
	getTop100Movies("D://Rtemp/movie_rating.txt", m);

	cout << "Read pageranks and top 100 movies Successfully! " << endl;

	ofstream outfile("D://Rtemp/Matrix.txt", ios::out | ios::app);

	if (outfile.fail())
	{
		cout << "Error opening the file Matrix.txt";
		exit(1);
	}

	

	//output_pr(id_pr);

	//getchar();
    
	//generate a big matrix 106 attributes
	for (map<string, vector<int> >::iterator it = filmMap.begin(); it != filmMap.end(); it++){
		//pageRank initialization
		float pageRank[5] = {0, 0, 0, 0, 0};

		//get PageRanks;
		vector<float> temp;
		for (int i = 0; i != (it->second).size(); i++)
			temp.push_back(id_pr[(it->second)[i]]);

		//increasing order
		sort(temp.begin(), temp.end(), comp);

		//return top 5 pageranks
		for (int i = 0; i != 5; i++)
			pageRank[i] = temp[i];

		int dir[101];
		// dir[101] initialization
		for (int j = 0; j != 101; j++)
			dir[j] = 0;

		map<string, vector<int>>::iterator ite = f2dMap.find(it->first);
		if (ite != f2dMap.end())//found this movie in moviename->did
		{
			for (vector<int>::iterator iter = (ite->second).begin(); iter != (ite->second).end(); iter++){//(*iter) did
				for (vector<int>::iterator itera = d2fMap[*iter].begin(); itera != d2fMap[*iter].end(); itera++){//check if this dir 's films(fid *itera) are among top 100
					map<int, string>::iterator ita = m.find(*itera);
					if (ita != m.end()){//find the film in top 100;
						dir[ita->first] ++;
					}
				}
			}
		}
		

		//write to a txt file
		
		

		for (int pi = 0; pi != 5; pi++) 
			outfile << pageRank[pi] << "\t";
		
		for (int di = 0; di != 101; di++)
				outfile << dir[di] << "\t";
		
		outfile << endl;
		
		

	}

	outfile.close();
	
	return 0;
}
