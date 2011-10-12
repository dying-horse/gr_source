#include <lauxlib.h>
#include <lua.h>

static int
gr_source_error(lua_State *L) {
 luaL_error(L, luaL_checkstring(L, -1));
 lua_pop(L, 2);
 return 0;
}

static luaL_Reg
gr_source_funcs[] = {
 { "error", &gr_source_error },
 { NULL, NULL }
};

int
luaopen_source_aux(lua_State *L) {
 luaL_register(L, "source", gr_source_funcs);

 return 0;
}
