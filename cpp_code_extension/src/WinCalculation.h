#ifndef WIN_CALCULATION_H
#define WIN_CALCULATION_H

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class WinCalculation : public Object
{
    GDCLASS(WinCalculation, Object)
private:
    bool dfs();

public:
    WinCalculation();
    ~WinCalculation();
    bool win_calculation(int state[], int player);
};

#endif