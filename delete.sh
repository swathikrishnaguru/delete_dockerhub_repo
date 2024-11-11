#!/bin/bash

NAMESPACE="clanmeetingvc"
TOKEN="token"
page=1

# Loop through all pages of repositories
while :; do
    # Get repositories from the current page
    repos=$(curl -s -H "Authorization: Bearer $TOKEN" "https://hub.docker.com/v2/repositories/$NAMESPACE/?page_size=100&page=$page" | jq -r '.results[].name')

    # If no repositories are found, break out of the loop
    if [ -z "$repos" ]; then
        echo "No more repositories found on page $page."
        break
    fi

    # Delete each repository
    for repo in $repos; do
        echo "Attempting to delete repository: $repo"
        curl -s -X DELETE -H "Authorization: Bearer $TOKEN" "https://hub.docker.com/v2/repositories/$NAMESPACE/$repo/"
        echo "Deleted $repo"
    done

    # Increment page number for pagination
    ((page++))
done
