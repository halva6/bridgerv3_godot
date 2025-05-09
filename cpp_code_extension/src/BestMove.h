#ifndef BESTMOVE_H
#define BESTMOVE_H

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/vector2.hpp>

using namespace godot;

class BestMove : public Object
{
    GDCLASS(BestMove, Object)

private:
    const int m_PLAYER_AI = 2;
    const int m_PLAYER_HUMAN = 1;
    const int m_ROWs = 13;
    const int m_COLS = 13;

    bool dfs();
    bool checkWin(Array *pState, int *pPlayer);
    int simulateRandomGame(Array *pState, int *pPlayer);
    void backpropagate();
    void monteCarloTreeSearch();

protected:
    static void _bind_methods();

public:
    BestMove();
    ~BestMove();
};

class Knot : public Object
{
private:
    int *pmPlayer;
    int mVisits;
    int mWins;

    Knot *pmParent;
    Array *pmState;
    Array mChildren;
    Array mUntriedMoves;

public:
    Knot();
    Knot(Array *state, Knot *parent, int *player);
    ~Knot();

    // Funktionen
    Array getLegalMoves() const;
    Knot *expand();
    int nextPlayer() const;
    bool fullyExpanded() const;
    Knot *bestUTC();
    Knot *bestChild();
};

#endif