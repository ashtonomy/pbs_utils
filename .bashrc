# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
# Add umls lexical tools
PATH="$HOME/nlp_research/umls_utils/lvg2023/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# ALIASES
alias lt='ls -lt'
alias s='cd /scratch/taw2/'
alias snlp='cd /scratch/taw2/nlp_research'
alias nlp='cd /home/taw2/nlp_research'
alias cap='cd /scratch/taw2/capstone'
alias ml='module list'
alias ma='module avail'
alias qt='qstat | grep taw2'
alias qta='qstat -Jt -u taw2'
alias qi='qsub -I -l'
alias q='qsub -I -l select=1:ncpus=16:mem=120gb:chip_manufacturer=intel,walltime=12:00:00'
alias src='source activate'
alias qa100='qstat | grep " 0 Q gpu_small_a100" | sort -n -k1'
alias py="python3"
alias cdnew="cd $(ls -t | head -n 1)"

# ENV VARS

export TUNE_RESULT_DIR="/scratch/taw2/.cache/raytune/"
export HF_HOME="/scratch/taw2/.cache/huggingface/"
export SCRATCH="/scratch/taw2/"

# FUN STUFF

# Uncomment for time stamp for cli
# export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ "

# FUNC-Y STUFF

# Print array with prepended index; starts from 1. Newline separated.
function print_arr { 
    arr=( "$@" )
    idx=1
    for n in "${arr[@]}"
    do
        echo -e "${idx}) ${n}"
        idx=$(( $idx + 1 ))
    done 
}

# Add a module using keyword <key> matching the form ...<key>.../.../...
# Key must be included in the base name (i.e. before the first /)
function mad {
    grep_str=$(module avail $1 |& grep -Eo " [^/ ]*$1\S*/\S*")
    readarray -t mods <<< "$grep_str"
    if [ ${#mods[@]} == 0 ]
    then
        echo "No modules found."
    elif [ ${#mods[@]} == 1 ]
    then
        module add ${mods[0]}
        echo "Added module ${mods[0]}"
    else
        echo "Found the following modules: "
        echo ""
        print_arr "${mods[@]}"
        echo ""
        read -t 15 -p "Which would you like to add? " idx || return
        idx=$(( $idx - 1 ))
        module add ${mods[$idx]} 
        echo "Added module ${mods[$idx]}"
    fi
}

# Same as above, but delete
function mdel {
    grep_str=$(module list |& grep -Eo " [^/ ]*$1\S*/\S*")
    readarray -t mods <<< "$grep_str"
    if [ ${#mods[@]} == 0 ]
    then
        echo "No modules found."
    elif [ ${#mods[@]} == 1 ]
    then
        module del ${mods[0]}
        echo "Deleted module ${mods[0]}"
    else
        echo "Found the following modules: "
        echo ""
        print_arr "${mods[@]}"
        echo ""
        read -t 15 -p "Which would you like to add? " idx || return
        idx=$(( $idx - 1 ))
        module del ${mods[$idx]} 
        echo "Deleted module ${mods[$idx]}"
    fi
}

source /etc/profile.d/bash_completion.sh
