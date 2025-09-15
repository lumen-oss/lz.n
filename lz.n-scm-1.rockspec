-- NOTE: This rockspec is used for running busted tests only,
-- not for publishing to LuaRocks.org

local _MODREV, _SPECREV = 'scm', '-1'
rockspec_format = '3.0'
package = 'lz.n'
version = _MODREV .. _SPECREV

dependencies = {
    'lua == 5.1',
}

test_dependencies = {
    'lua == 5.1',
}

source = {
    url = 'git://github.com/lumen-oss/' .. package,
}

build = {
    type = 'builtin',
}
