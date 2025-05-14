#include "Knot.hpp"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/ref.hpp>
#include <cmath>
#include <algorithm>
#include <random>

using namespace godot;

Knot::Knot() {}
Knot::~Knot() {}

void Knot::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("init", "state", "game_board_size", "parent", "player"), &Knot::init, DEFVAL(nullptr), DEFVAL(PLAYER_AI));
    ClassDB::bind_method(D_METHOD("expand"), &Knot::expand);
    ClassDB::bind_method(D_METHOD("fully_expanded"), &Knot::fully_expanded);
    ClassDB::bind_method(D_METHOD("best_uct"), &Knot::best_uct);
    ClassDB::bind_method(D_METHOD("best_child"), &Knot::best_child);
    ClassDB::bind_method(D_METHOD("get_state"), &Knot::get_state);
    ClassDB::bind_method(D_METHOD("get_visits"), &Knot::get_visits);
}

void Knot::init(Array state_gd, int board_size, Ref<Knot> parent_ref, int player_val)
{
    game_board_size = board_size;
    parent = parent_ref;
    player = player_val;
    state.resize(board_size, std::vector<int>(board_size, 0));
    for (int i = 0; i < board_size; ++i)
    {
        Array row = state_gd[i];
        for (int j = 0; j < board_size; ++j)
        {
            state[i][j] = row[j];
        }
    }
    untried_moves.clear();
    Array moves = get_legal_moves();
    for (int i = 0; i < moves.size(); ++i)
        untried_moves.push_back(moves[i]);
}

Array Knot::get_legal_moves() const
{
    Array moves;
    for (int r = 0; r < game_board_size; ++r)
    {
        for (int c = 0; c < game_board_size; ++c)
        {
            if (state[r][c] == 0)
                moves.append(Vector2(r, c));
        }
    }
    return moves;
}

Ref<Knot> Knot::expand()
{
    Vector2 move = untried_moves.back();
    untried_moves.pop_back();
    std::vector<std::vector<int>> new_state = state;
    new_state[(int)move.x][(int)move.y] = next_player();

    // Convert new_state to Array
    Array new_state_gd;
    for (int i = 0; i < game_board_size; ++i)
    {
        Array row;
        for (int j = 0; j < game_board_size; ++j)
            row.append(new_state[i][j]);
        new_state_gd.append(row);
    }

    Ref<Knot> child = memnew(Knot);
    child->init(new_state_gd, game_board_size, this, next_player());
    children.push_back(child);
    return child;
}

int Knot::next_player() const
{
    return player == PLAYER_AI ? PLAYER_HUMAN : PLAYER_AI;
}

bool Knot::fully_expanded() const
{
    return untried_moves.empty();
}

Ref<Knot> Knot::best_uct() const
{
    double log_N_parent = log((double)visits);
    Ref<Knot> best_node = nullptr;
    double best_score = -INFINITY;
    for (const auto &child : children)
    {
        double uct_score = 0.0;
        if (child->visits > 0)
        {
            uct_score = (double)child->wins / child->visits +
                        sqrt(2.0 * log_N_parent / child->visits);
        }
        else
        {
            uct_score = INFINITY;
        }
        if (uct_score > best_score)
        {
            best_score = uct_score;
            best_node = child;
        }
    }
    return best_node;
}

Ref<Knot> Knot::best_child() const
{
    Ref<Knot> best_node = nullptr;
    int most_visits = -1;
    for (const auto &child : children)
    {
        if (child->visits > most_visits)
        {
            most_visits = child->visits;
            best_node = child;
        }
    }
    return best_node;
}

Array Knot::get_state() const
{
    Array state_gd;
    for (const auto &row : state)
    {
        Array row_gd;
        for (int cell : row)
            row_gd.append(cell);
        state_gd.append(row_gd);
    }
    return state_gd;
}

int Knot::get_visits() const
{
    return visits;
}