#!/bin/bash

BASE_URL="https://api.github.com"

HEADER_ACCEPT="Accept: application/vnd.github.v3+json"
HEADER_AUTH="Authorization: token ${GITHUB_API_TOKEN}"






LAST_WEEK=`date -d "$report_duration" --iso-8601`

# TODO: This will include PRS, should we filter out?
ISSUES_URL="${BASE_URL}/orgs/CircleCI-Public/issues?filter=all&since=${LAST_WEEK}&state=closed"

echo "Calling $ISSUES_URL"

curl -H "$HEADER_ACCEPT" \
	 -H "$HEADER_AUTH" \
	"$ISSUES_URL" \
| jq '[ (.[] | (.created_at | fromdateiso8601) as $start | (.closed_at | fromdateiso8601) as $close | { "issue_id": .id, "created_at": .created_at, "closed_at": .closed_at, "duration_days": ( ( $close - $start)/60/60/24 ) }) ]  |  ( [ .[].duration_days ] | length as $array_length | add / $array_length | . )  as $avg | { "issues": . , "avg": $avg}' \
> closed_durations.json

echo "See closed_durations,json for full details."

jq '{"Avg":.avg}' closed_durations.json



#[ (.[] | (.created_at | fromdateiso8601) as $start | (.closed_at | fromdateiso8601) as $close | { "issue_id": .id, "created_at": .created_at, "closed_at": .closed_at, "duration_days": ( ( $close - $start)/60/60/24 ) }) ]  |  ( [ .[].duration_days ] | length as $array_length | add / $array_length | . )  as $avg | {"avg": $avg, "issues": . }