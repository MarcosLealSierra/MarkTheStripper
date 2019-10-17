#!/bin/bash

# Actualizar plugins de Vim.
# Copyright © 2018 Marcos Leal Sierra <marcoslealsierra90@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

path_plugins=$HOME/.vim/pack/plugins/start
separador="\n----------------------------------------------------------\n"

for i in $path_plugins/*; do
    plugin=$(basename $i)
    if [[ -d $i ]] && [[ -d $i/.git ]]; then
        echo -e "Plugin: $GREEN $plugin $NC \n"
        git -C $i pull -v
        echo -e $separador
    else
        echo -e "Plugin: $RED $plugin $NC \n"
        echo "$plugin no tiene repositorio"
        echo -e $separador
    fi
done
