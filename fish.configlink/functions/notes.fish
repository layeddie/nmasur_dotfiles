#!/usr/local/bin/fish

function notes --description "Notes functions"

    function journal --description "Create today's journal"
        set today (date -j +"%Y-%m-%d_%a")
        set today_journal $HOME/Documents/notes/$today.md
        if [ -f $today_journal ]
            echo "Already exists."
        else
            set yesterday (date -jv "-1d" +"%Y-%m-%d_%a")
            set tomorrow (date -jv "+1d" +"%Y-%m-%d_%a")
            set weather (curl -s "https://wttr.in/?format=1")
            printf "[[$yesterday|Previous]] - [[calendar|Index]] - [[$tomorrow|Next]]\n\n---\n\n$weather\n\n# Tasks\n\n\n# Log\n\n\n# Communication\n\n---\n\n# Meetings\n\n" > $today_journal
            echo "New journal added."
        end
    end

    function today --description "Open today's journal"
        cd $HOME/Documents/notes
        set today (date -j +"%Y-%m-%d_%a")
        set today_journal $today.md
        if [ -f $today_journal ]
            vim $today_journal
        else
            set yesterday (date -jv "-1d" +"%Y-%m-%d_%a")
            set tomorrow (date -jv "+1d" +"%Y-%m-%d_%a")
            set weather (curl -s "https://wttr.in/?format=1")
            printf "[[$yesterday|Previous]] - [[calendar|Index]] - [[$tomorrow|Next]]\n\n---\n\n$weather\n\n# Tasks\n\n\n# Log\n\n\n# Communication\n\n---\n\n# Meetings\n\n" > $today_journal
            echo "New journal added."
            vim $today_journal
        end
        cd -
    end

    function wiki --description "Open vimwiki file"
        cd $HOME/Documents/notes
        set file (ls | fzf)
        if [ $status -eq 0 ]
            vim $file
        end
        cd -
    end

    function note --description "Edit or create a note"
        vim ~/Documents/notes/$argv[1].md
    end

    abbr -a sn 'syncnotes'
    function syncnotes --description "Full git commit on notes"
        cd $HOME/Documents/notes
        git pull
        git add -A
        git commit -m "autosync"
        git push
        cd -
    end

end