#include <iostream>
#include <vector>
#include <queue>
#include <cmath>
#include <climits>
#include <fstream>
#include <sstream>
#include <chrono>

using namespace std;

struct Node {
    vector<pair<int, int>> path;
    vector<bool> visited;
    int bound;
    int current_cost;
    int current_city;
    int level;

    bool operator>(const Node& other) const {
        return bound > other.bound;
    }
};

int firstMin(const vector<vector<int>>& adj, int i) {
    int min_val = INT_MAX;
    int N = adj.size();
    for (int k = 0; k < N; k++)
        if (adj[i][k] < min_val && i != k)
            min_val = adj[i][k];
    return min_val;
}

int secondMin(const vector<vector<int>>& adj, int i) {
    int first = INT_MAX, second = INT_MAX;
    int N = adj.size();
    for (int j = 0; j < N; j++) {
        if (i == j) continue;
        if (adj[i][j] <= first) {
            second = first;
            first = adj[i][j];
        } else if (adj[i][j] <= second && adj[i][j] != first) {
            second = adj[i][j];
        }
    }
    return second;
}

void solveTSP(const vector<vector<int>>& adj, const string& filename) {
    int N = adj.size();
    if (N == 0) return;

    priority_queue<Node, vector<Node>, greater<Node>> pq;
    Node root;

    root.visited.assign(N, false);
    root.visited[0] = true;
    root.current_city = 0;
    root.current_cost = 0;
    root.level = 0;

    int initial_bound = 0;
    for (int i = 0; i < N; i++) {
        initial_bound += (firstMin(adj, i) + secondMin(adj, i));
    }
    root.bound = ceil((double)initial_bound / 2);

    pq.push(root);

    int final_res = INT_MAX;
    vector<pair<int, int>> final_path;
    
    auto start_time = chrono::steady_clock::now();
    bool timeout = false;

    while (!pq.empty()) {
        auto current_time = chrono::steady_clock::now();
        if (chrono::duration_cast<chrono::seconds>(current_time - start_time).count() >= 15) {
            timeout = true;
            break;
        }

        Node curr = pq.top();
        pq.pop();

        if (curr.bound >= final_res) {
            continue; 
        }

        if (curr.level == N - 1) {
            int last_to_first_cost = adj[curr.current_city][0];
            if (last_to_first_cost != 0) {
                int curr_res = curr.current_cost + last_to_first_cost;
                if (curr_res < final_res) {
                    final_res = curr_res;
                    final_path = curr.path;
                    final_path.push_back({curr.current_city, 0});
                }
            }
            continue;
        }

        for (int i = 0; i < N; i++) {
            if (adj[curr.current_city][i] != 0 && !curr.visited[i]) {
                Node next;
                next.visited = curr.visited;
                next.visited[i] = true;
                next.path = curr.path;
                next.path.push_back({curr.current_city, i});
                next.current_city = i;
                next.current_cost = curr.current_cost + adj[curr.current_city][i];
                next.level = curr.level + 1;

                int temp = curr.bound;
                if (curr.level == 0) {
                    temp -= ((firstMin(adj, curr.current_city) + firstMin(adj, i)) / 2);
                } else {
                    temp -= ((secondMin(adj, curr.current_city) + firstMin(adj, i)) / 2);
                }
                next.bound = temp + adj[curr.current_city][i];

                if (next.bound < final_res) {
                    pq.push(next);
                }
            }
        }
    }

    cout << "--- Resultado para " << filename << " (" << N << " cidades) ---\n";
    if (timeout) {
        cout << "Status: Limite de tempo 15s) excedido!\n";
    } else {
        cout << "Status: Executado com sucesso.\n";
    }

    if (final_res == INT_MAX) {
        cout << "Nenhuma rota completa foi encontrada no tempo disponivel.\n\n";
    } else {
        cout << "Custo minimo encontrado: " << final_res << "\nCaminho: ";
        for (size_t i = 0; i < final_path.size(); i++) {
            cout << final_path[i].first << " -> ";
            if (i == final_path.size() - 1) cout << final_path[i].second;
        }
        cout << "\n\n";
    }
}

vector<vector<int>> readMatrix(const string& filename) {
    ifstream file(filename);
    vector<vector<int>> adj;
    string line;
    
    if (!file.is_open()) {
        cout << "Erro ao abrir o arquivo: " << filename << "\n\n";
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
        cout << "Processando " << file << "...\n";
        vector<vector<int>> adj = readMatrix(file);
        
        if (!adj.empty()) {
            solveTSP(adj, file);
        }
    }

    return 0;
}