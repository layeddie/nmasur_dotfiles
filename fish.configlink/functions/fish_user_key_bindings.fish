#!/usr/local/bin/fish

function fish_user_key_bindings
    bind -M insert \co 'edit'
    bind -M insert \ca 'cd; and edit; cd -'
    bind -M insert \ce 'recent'
    bind -M insert \cg 'commandline-git-commits'
    bind -M insert \cf 'fcd'
    bind -M insert \cp 'prj'
    bind -M default \cp 'prj'
    bind -M insert \x1F accept-autosuggestion
    bind -M default \x1F accept-autosuggestion
end
