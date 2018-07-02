#!/bin/bash

function append_and_commit()
{
    local local_branch_name=$( echo $1 | cut -d'-' -f3 )
    local remote_name_dash_branch_name=$( echo $1 | cut -d'-' -f2,3 )
    local file_name_to_be_appended_and_committed="index_${remote_name_dash_branch_name}.html"
    local file_content=$1
    local commit_message=$1

    git checkout $local_branch_name

    echo $file_content >> $file_name_to_be_appended_and_committed

    git add $file_name_to_be_appended_and_committed

    git commit -m "$commit_message"

    sleep 1
}

# localrepo is used to distinguish the local commits from the remote commits
append_and_commit "C8-localrepo-alpha"

append_and_commit "C9-localrepo-master"

append_and_commit "C10-localrepo-master"

append_and_commit "C11-localrepo-master"

echo "$0 completed!"
