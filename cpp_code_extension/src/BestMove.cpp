#include "BestMove.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/vector2.hpp>

using namespace godot;

void BestMove::_bind_methods()
{
}

BestMove::BestMove() {}
Knot::Knot() {}

Knot::Knot(Array *state, Knot *parent, int *player)
{
    pmState = state;
    pmParent = parent;
    pmPlayer = player;
}