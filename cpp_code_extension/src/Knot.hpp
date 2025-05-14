#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/variant/vector2.hpp>
#include <godot_cpp/classes/ref.hpp>
#include <godot_cpp/classes/ref_counted.hpp>

#include <vector>
#include <memory>

namespace godot
{

    class Knot : public godot::RefCounted
    {
        GDCLASS(Knot, RefCounted);

    protected:
        static void _bind_methods();

    public:
        static const int PLAYER_AI = 2;
        static const int PLAYER_HUMAN = 1;

        std::vector<std::vector<int>> state;
        Ref<Knot> parent;
        std::vector<Ref<Knot>> children;
        int visits = 0;
        int wins = 0;
        int player;
        std::vector<Vector2> untried_moves;
        int game_board_size;

        Knot();
        ~Knot();
        void init(Array state_gd, int game_board_size, Ref<Knot> parent = nullptr, int player = PLAYER_AI);

        Array get_legal_moves() const;
        Ref<Knot> expand();
        int next_player() const;
        bool fully_expanded() const;
        Ref<Knot> best_uct() const;
        Ref<Knot> best_child() const;

        Array get_state() const;

        int get_visits() const;
    };

}
