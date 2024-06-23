#!/bin/bash

set -uo pipefail

WORK="mnt/6TB/work"

export SESSIONS="local vps-bc vps-xss axiom"


function session-local {
    tmux new-session -d -s ${1} -n 'Recon' -c "${WORK}"

    tmux new-window -n "Passive" -t ${1} -c "${$1}"

    tmux split-window -v -t ${1}:1 -c "${WORK}/../"

    tmux send-keys -t ${1}:1.1 './Recon-Passive.sh'              
    tmux send-keys -t ${1}:1.2 'sc' Enter

    tmux select-window -t ${1}:1
}

function session-vps-bc {
    tmux new-session -d -s ${1} -n 'Recon' -c "${HOME}"

    tmux new-window -n "Active"  -t ${1} -c "${WORK}"

    tmux split-window -h -t ${1}:1 -c "${HOME}"

    tmux send-keys -t ${1}:1.1 'bc' Enter
    tmux send-keys -t ${1}:1.2 'sc' Enter

    tmux select-window -t ${1}:1
}


function session-vps-xss {
    tmux new-session -d -s ${1} -n 'Fuzz' -c "${HOME}"

    tmux new-window -n "Discovery"   -t ${1} -c "${WORK}"

    tmux split-window -v -t ${1}:1 -c "${HOME}"

    tmux send-keys -t ${1}:1.1 'xss'  Enter 'tmux a' Enter
    tmux send-keys -t ${1}:1.2 'tmux attach -t local' Enter

    tmux select-window -t ${1}:1
}

function session-axiom {
    tmux new-session -d -s ${1} -n 'fleet' -c "${HOME}"

    tmux new-window -n "xploit" -t ${1} -c "${HOME}/tools/scripts"
    
    tmux split-window -h -t ${1}:1 -c "${HOME}"
    
    tmux send-keys -t ${1}:1.1 'sc' Enter
    
    tmux send-keys -t ${1}:1.2 'ls' Enter

    tmux select-window -t ${1}:1
}

# --------------------------------


for session in ${SESSIONS}; do
    tmux has-session -t ${session} 2>/dev/null
    if [[ $? == 0 ]]; then
        echo "Session '${session}' already exists"
        continue
    fi

    session-${session} ${session}
    echo "Session '${session}' was created"
done
