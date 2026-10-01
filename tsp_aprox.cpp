#include <iostream>
#include <vector>
#include <climits>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;

void solveTSPNearestNeighbor(const vector<vector<int>>& adj, const string& filename) {
    int num_cities = adj.size();
    if (num_cities == 0) return;

    vector<bool> visited(num_cities, false);
    vector<int> path;
    
    int total_cost = 0;
    int current_city = 0;
    
    visited[current_city] = true;
    path.push_back(current_city);

    cout << "=====================================================\n";
    cout << "Instancia: " << filename << " (" << num_cities << " cidades)\n";
    cout << "-----------------------------------------------------\n";

    for (int step = 0; step < num_cities - 1; step++) {
        int nearest_city = -1;
        int min_distance = INT_MAX;

        for (int next_city = 0; next_city < num_cities; next_city++) {
            if (!visited[next_city] && adj[current_city][next_city] < min_distance) {
                min_distance = adj[current_city][next_city];
                nearest_city = next_city;
            }
        }

        if (nearest_city == -1) break;

        visited[nearest_city] = true;
        path.push_back(nearest_city);
        total_cost += min_distance;
        
        current_city = nearest_city;
    }

    int return_cost = adj[current_city][0];
    total_cost += return_cost;
    path.push_back(0);
    
    cout << "Custo total aproximado: " << total_cost << "\n";
    cout << "Rota seguida: ";
    for (size_t i = 0; i < path.size(); i++) {
        cout << path[i];
        if (i < path.size() - 1) cout << " -> ";
    }
    cout << "\n\n";
}

vector<vector<int>> readMatrix(const string& filename) {
    ifstream file(filename);
    vector<vector<int>> adj;
    string line;
    
    if (!file.is_open()) {
        cerr << "Erro ao abrir o ficheiro: " << filename << "\n\n";
        return adj;
    }

    while (getline(file, line)) {
        if (line.empty()) continue;
        stringstream ss(line);
        int val;
        vector<int> row;
        while (ss >> val) {
            row.push_back(val);
        }
        if (!row.empty()) {
            adj.push_back(row);
        }
    }
    return adj;
}

int main() {
    vector<string> files = {
        "tsp1_253.txt",
        "tsp2_1248.txt",
        "tsp3_1194.txt",
        "tsp4_7013.txt",
        "tsp5_27603.txt"
    };

    for (const string& file : files) {
        vector<vector<int>> adj = readMatrix(file);
        
        if (!adj.empty()) {
            solveTSPNearestNeighbor(adj, file);
        }
    }

    return 0;
}