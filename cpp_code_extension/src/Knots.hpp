#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/variant/vector2.hpp>
#include <godot_cpp/classes/ref.hpp>
#include "Knot.hpp"

namespace godot
{

    class Knots : public Object
    {
        GDCLASS(Knots, Object);

    protected:
        static void _bind_methods();

    public:
        Knots();

        static bool check_win(Array matrix, int player, int board_size);
        static bool dfs(Array matrix, int row, int col, int player, Array visited, Array directions, int board_size);
        static int simulate_random_game(Array state, int player, int board_size);
        static void backpropagate(Ref<Knot> node, int result);
        static Ref<Knot> monte_carlo_tree_search(Ref<Knot> root, double simulation_time, int board_size);
    };

}
