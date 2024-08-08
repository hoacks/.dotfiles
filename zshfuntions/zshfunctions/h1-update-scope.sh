
h1-scope(){
h1name="hoacks"
apitoken="ll6hI4vilFg04DULeRAV6kcWNBHkO/zYbqz46rryX80="



  curl -g -s 'https://api.hackerone.com/v1/hackers/programs/'"$1" -u $h1name:$apitoken | tee \
       >( jq '.relationships.structured_scopes.data[].attributes | select((.asset_type == "URL" or .asset_type == "WILDCARD") and .eligible_for_bounty and .eligible_for_submission) | .asset_identifier' -r | bbrf inscope add - -p "$1") \
       >( jq '.relationships.structured_scopes.data[].attributes | select((.asset_type == "URL" or .asset_type == "WILDCARD") and .eligible_for_submission == false) | .asset_identifier' -r | bbrf outscope add - -p "$1" ) \
       > /dev/null
  

}
