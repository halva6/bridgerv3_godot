#include "Knots.hpp"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/ref.hpp>

#include <random>

using namespace godot;

Knots::Knots() {}

void Knots::_bind_methods()
{
    ClassDB::bind_static_method("Knots", D_METHOD("check_win", "matrix", "player", "board_size"), &Knots::check_win);
    ClassDB::bind_static_method("Knots", D_METHOD("dfs", "matrix", "row", "col", "player", "visited", "directions", "board_size"), &Knots::dfs);
    ClassDB::bind_static_method("Knots", D_METHOD("simulate_random_game", "state", "player", "board_size"), &Knots::simulate_random_game);
    ClassDB::bind_static_method("Knots", D_METHOD("backpropagate", "node", "result"), &Knots::backpropagate);
    ClassDB::bind_static_method("Knots", D_METHOD("monte_carlo_tree_search", "root", "simulation_time", "board_size"), &Knots::monte_carlo_tree_search);
}

bool Knots::check_win(Array matrix, int player, int board_size)
{
    Array directions;
    directions.append(Vector2(1, 0));
    directions.append(Vector2(0, 1));
    directions.append(Vector2(-1, 0));
    directions.append(Vector2(0, -1));

    if (player == 1)
    {
        // Player 1: top to bottom
        for (int start_col = 0; start_col < board_size; ++start_col)
        {
            Array row = matrix[0];
            if ((int)row[start_col] == player)
            {
                Array visited;
                if (dfs(matrix, 0, start_col, player, visited, directions, board_size))
                    return true;
            }
        }
    }
    else if (player == 2)
    {
        // Player 2: left to right
        for (int start_row = 0; start_row < board_size; ++start_row)
        {
            Array row = matrix[start_row];
            if ((int)row[0] == player)
            {
                Array visited;
                if (dfs(matrix, start_row, 0, player, visited, directions, board_size))
                    return true;
            }
        }
    }
    return false;
}

bool Knots::dfs(Array matrix, int row, int col, int player, Array visited, Array directions, int board_size)
{
    if (player == 1 && row == board_size - 1)
        return true;
    if (player == 2 && col == board_size - 1)
        return true;

    Vector2 pos(row, col);
    visited.append(pos);

    for (int i = 0; i < directions.size(); ++i)
    {
        Vector2 dir = directions[i];
        int new_row = row + (int)dir.x;
        int new_col = col + (int)dir.y;
        if (new_row >= 0 && new_row < board_size && new_col >= 0 && new_col < board_size)
        {
            Vector2 new_pos(new_row, new_col);
            bool already_visited = false;
            for (int j = 0; j < visited.size(); ++j)
            {
                if (visited[j] == new_pos)
                {
                    already_visited = true;
                    break;
                }
            }
            Array row = matrix[new_row];
            if (!already_visited && (int)row[new_col] == player)
            {
                if (dfs(matrix, new_row, new_col, player, visited, directions, board_size))
                    return true;
            }
        }
    }
    return false;
}

int Knots::simulate_random_game(Array state_gd, int player, int board_size)
{
    Array state;
    for (int i = 0; i < state_gd.size(); ++i)
        state.append(state_gd[i].duplicate(true));
    int current_player = player;
    std::random_device rd;
    std::mt19937 rng(rd());

    while (true)
    {
        Array moves;
        for (int r = 0; r < board_size; ++r)
        {
            Array row = state[r];
            for (int c = 0; c < board_size; ++c)
            {
                if ((int)row[c] == 0)
                    moves.append(Vector2(r, c));
            }
        }
        if (moves.is_empty())
            break;
        else if (check_win(state, Knot::PLAYER_HUMAN, board_size))
            return -1;
        else if (check_win(state, Knot::PLAYER_AI, board_size))
            return 1;

        std::uniform_int_distribution<int> dist(0, moves.size() - 1);
        Vector2 move = moves[dist(rng)];
        Array row = state[(int)move.x];
        row[(int)move.y] = current_player;
        state[(int)move.x] = row;
        current_player = (current_player == Knot::PLAYER_AI) ? Knot::PLAYER_HUMAN : Knot::PLAYER_AI;
    }

    if (check_win(state, Knot::PLAYER_AI, board_size))
        return 1;
    else if (check_win(state, Knot::PLAYER_HUMAN, board_size))
        return -1;
    return 0;
}

void Knots::backpropagate(Ref<Knot> node, int result)
{
    while (node.is_valid())
    {
        node->visits += 1;
        if ((node->player == Knot::PLAYER_AI && result == 1) ||
            (node->player == Knot::PLAYER_HUMAN && result == -1))
        {
            node->wins += 1;
        }
        node = node->parent;
    }
}

Ref<Knot> Knots::monte_carlo_tree_search(Ref<Knot> root, double simulation_time, int board_size)
{
    double start_time = Time::get_singleton()->get_unix_time_from_system();
    while (Time::get_singleton()->get_unix_time_from_system() - start_time < simulation_time)
    {
        Ref<Knot> node = root;
        while (node->fully_expanded() && !node->children.empty())
            node = node->best_uct();
        if (!node->untried_moves.empty())
            node = node->expand();

        int result = simulate_random_game(node->get_state(), node->player, board_size);
        backpropagate(node, result);
    }
    UtilityFunctions::print(String("[DEBUG] Visits: ") + String::num_int64(root->visits));
    return root->best_child();
}
