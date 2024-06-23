

# Agregar inscope outscope from H1 program to BBRF

for p in $(cat programs.txt);do curl -g -s 'https://api.hackerone.com/v1/hackers/programs/'$p -u $h1name:$apitoken | tee \
       >( jq '.relationships.structured_scopes.data[].attributes | select(.asset_type == "URL" and .eligible_for_bounty and .eligible_for_submission and .archived_at == null) | .asset_identifier' -r | bbrf inscope add - -p $p) \
       >( jq '.relationships.structured_scopes.data[].attributes | select(.asset_type == "URL" and .eligible_for_submission == false and .archived_at == null) | .asset_identifier' -r | bbrf outscope add - -p $p );done

