#/bin/bash

# PRINT "INPUT YOUR INTRA ID"
echo "Enter Your Intra ID: "
read intra_id

#FILE READ
if [ -f .env ]; then
	echo "Reading .env file"
	source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# (LOGIN) GET ACCESS_TOKEN FROM API (GET INTRA TOKEN)



# echo "Welcome ${intra_id}" 
access_token=$(curl -X POST --data "grant_type=client_credentials&client_id=${INTRA_API_ID}&client_secret=${INTRA_API_SECRET}" https://api.intra.42.fr/oauth/token | jq -r '.access_token') 2>/dev/null
# Check if access_token is empty or invalid
if [ -z "$access_token" ]; then
    echo "Error getting access token. Please check your credentials."
    exit 1
fi
# USE /v2/{intra_id}/campus_users
campus_info=$(curl -s -H "Authorization: Bearer ${access_token}" https://api.intra.42.fr/v2/users/${intra_id}/campus_users | jq -e '.[0].campus_id') 2>/dev/null

# Check if campus_info is not null and a valid number
if [ -z "$campus_info" ] || ! [[ "$campus_info" =~ ^[0-9]+$ ]]; then
    echo "Error retrieving campus information."
    exit 1
fi


kr=29
fr=1 

# MATCHING CAMPUS_ID WITH COUNTRY (fr, kr ... etc)
if [ "$campus_info" = "$kr" ]; then 
  cat gyeongbok_palace.txt
elif [ "$campus_info" = "$fr" ]; then
  cat eiffel_tower.txt
else
  echo "We only support FR and KR. Wait for updates."
fi



