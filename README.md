# Githib Reporting with JQ

Pulls useful stats from GH API.


## Adhoc triggers
This job runs nightly, if you need dynamic, use conditional API

```
curl -u ${CIRCLE_TOKEN}: -X POST --header "Content-Type: application/json" -d '{
  "parameters": {
    "adhoc": true
    "duration": "-1 month"
  }
}' https://circleci.com/api/v2/project/github/eddiewebb/github-reporting/pipeline
```