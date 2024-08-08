getDomains()
{
    #thread configs
    dnsxThreads=200
    subfinderThreads=100
    gauThreads=30
    resolvers='~/wordlist/resolvers.txt'
    #no params
    program="$1"
    
    #check if program exists
    #stores the return value of the showProgram function
    IFS=$'\n'
    scopeIn=$(bbrf scope in -p $program)
    echo "$scopeIn"|bbrf domain add - -p $program --show-new
    wild=$(bbrf scope in --wildcard -p $program| grep -v DEBUG)
    if [[ ${#wild} -gt 0 ]]; then
        echo "$wild"|bbrf inscope add - -p $program
        echo "$wild"|bbrf domain add - -p $program --show-new

        echo -ne "${RED} Running amass ${ENDCOLOR}\n"
        if [[ -f "$AMASS_CONFIG" ]]; then
            :  #echo -ne "\t ${YELLOW} amass using $AMASS_CONFIG config file\n${ENDCOLOR}"
        else
            echo -ne "\t${RED} amass not using a config file, $AMASS_CONFIG not found\n${ENDCOLOR}"
        fi

        if [[ "$fileMode" = true ]] ; then
            for domain in $(echo "$wild"); do
                echo -ne "${YELLOW}  Querying $domain ${ENDCOLOR}\n"
                #change to find SERVAIL domains, saving also domains not resolving
               amass enum -d $domain -config $AMASS_CONFIG -passive 2>/dev/null | dnsx -t $dnsxThreads -silent -r $resolvers |tee --append "$tempFile-amass.txt"
#                amass enum -d $domain -config $AMASS_CONFIG -passive  --exclude Robtex,NetworkDB,Umbrella 2>/dev/null  |tee --append "$tempFile-amass.txt"
            done
            else
                for domain in $(echo "$wild"); do
                    echo -ne "${YELLOW}  Querying $domain ${ENDCOLOR}\n"
                    #change to find SERVAIL domains, saving also domains not resolving
                    amass enum -d $domain -config $AMASS_CONFIG -passive 2>/dev/null | dnsx -t $dnsxThreads -silent -r $resolvers | bbrf domain add - -s amass -p $program --show-new
             #       amass enum -d $domain -config $AMASS_CONFIG -passive --exclude Robtex,NetworkDB,Umbrella 2>/dev/null | grep -v '^_'| bbrf domain add - -s amass -p $program --show-new
                done
            fi
            echo -ne "${RED} Running subfinder ${ENDCOLOR}\n"
            if [[ "$fileMode" = true ]]; then
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|subfinder -all -t $subfinderThreads -silent |dnsx -t $dnsxThreads -silent -r $resolvers |tee --append "$tempFile-subfinder.txt"
                echo "$wild"|subfinder -all -t $subfinderThreads -silent |tee --append "$tempFile-subfinder.txt"
            else
                echo "$wild"|subfinder -all -t $subfinderThreads -silent | grep -v '^_' | dnsx -t $dnsxThreads -silent -r $resolvers |bbrf domain add - -s subfinder -p $program --show-new
            fi
 
            echo -ne "${RED} Running assetfinder ${ENDCOLOR}\n"
            if [[ "$fileMode" = true ]]; then
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|assetfinder|dnsx -t $dnsxThreads -silent -r $resolvers|tee --append "$tempFile-assetfinder.txt"
                echo "$wild"|assetfinder --subs-only|tee --append "$tempFile-assetfinder.txt"
            else
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|assetfinder|dnsx -t $dnsxThreads -silent -r $resolvers|bbrf domain add - -s assetfinder -p $program --show-new
                echo "$wild"|assetfinder --subs-only|bbrf domain add - -s assetfinder -p $program --show-new
            fi


 #           echo -ne "${RED} Running haktrails ${ENDCOLOR}\n"
  #          if [[ "$fileMode" = true ]]; then
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|haktrails|dnsx -t $dnsxThreads -silent -r $resolvers|tee --append "$tempFile-haktrails.txt"
   #             echo "$wild"|haktrails subdomains|tee --append "$tempFile-haktrails.txt"
   #         else
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|haktrails|dnsx -t $dnsxThreads -silent -r $resolvers|bbrf domain add - -s haktrails -p $program --show-new
#                echo "$wild"|haktrails subdomains |bbrf domain add - -s haktrails -p $program --show-new
    #        fi


            echo -ne "${RED} Running cloud_recon ${ENDCOLOR}\n"
            if [[ "$fileMode" = true ]]; then
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|cloud_recon|dnsx -t $dnsxThreads -silent -r $resolvers|tee --append "$tempFile-cloud.txt"
                echo "$wild"|cloud_recon subdomains|tee --append "$tempFile-cloud.txt"
            else
                #change to find SERVAIL domains, saving also domains not resolving
                #echo "$wild"|cloud_recon|dnsx -t $dnsxThreads -silent -r $resolvers|bbrf domain add - -s cloud -p $program --show-new
		domain=$(echo $wild | sed 's/\*\.//g')
               cat /home/joaco/NAS/data/Cloud_Recon/*.txt | rg -F "$domain" | awk -F '--' '{print $2}' | tr ' ' '\n' | tr '[]' ' ' | rg -F "$domain" | grep -v '\*\.' | grep -v '^ ' |  sort -u |  bbrf domain add - -s cloud -p $program --show-new
            fi

#            echo -ne "${RED} Running crt.sh ${ENDCOLOR}\n"
#            if [[ "$fileMode" = true ]]; then
#                #change to find SERVAIL domains, saving also domains not resolving
#                #echo "$wild"|crt.sh|dnsx -t $dnsxThreads -silent -r $resolvers|tee --append "$tempFile-crt.txt"
#                echo "$wild"|crt.sh subdomains|tee --append "$tempFile-crt.txt"
#            else
#                #change to find SERVAIL domains, saving also domains not resolving
#                #echo "$wild"|crt.sh|dnsx -t $dnsxThreads -silent -r $resolvers|bbrf domain add - -s crt -p $program --show-new
#                echo "$wild" | unfurl format %r |   curl -s 'https://crt.sh/?q=%22The+Coca-Cola+Company%22&output=json' | jq '.[] | .common_name' -r | sort -u | bbrf domain add - -s crt -p $program --show-new
#            fi
#
#            echo -ne "${RED} Running github-subdomains ${ENDCOLOR}\n"
#            if [[ "$fileMode" = true ]]; then
#                #change to find SERVAIL domains, saving also domains not resolving
#                #echo "$wild"|github-subdomains|dnsx -t $dnsxThreads -silent -r $resolvers|tee --append "$tempFile-haktrails.txt"
#                echo "$wild"|github-subdomains subdomains|tee --append "$tempFile-haktrails.txt"
#            else
#                #change to find SERVAIL domains, saving also domains not resolving
#                #echo "$wild"|github-subdomains|dnsx -t $dnsxThreads -silent -r $resolvers|bbrf domain add - -s haktrails -p $program --show-new
#                github-subdomains -d "$wild" -k -raw -t ~/.tokens |bbrf domain add - -s haktrails -p $program --show-new
#            fi

	    
            echo -ne "${RED} Running gau ${ENDCOLOR}\n"
            gau=$(gau --subs "$wild" --threads $gauThreads| unfurl -u domains)
                #gau --subs "$wild" --threads $gauThreads| unfurl -u domains | dnsx -t $dnsxThreads -silent -r $resolvers| bbrf domain add - -s gau -p $program --show-new
            echo "$gau" | bbrf domain add - -s gau -p $program --show-new
#                echo "$gau-urls" | bbrf url add - -s gau -p $program --show-new

#            #echo -ne "${RED} Running waybackurls ${ENDCOLOR}\n"
#            wayback=$(echo "$wild"| waybackurls| unfurl -u domains)
#            if [[ "$fileMode" = true ]] ; then
#                echo "$wayback"| tee --append "$tempFile-waybackurls.txt"
#             else
#                echo "$wayback"| bbrf domain add - -s waybackurls -p $program --show-new
#            fi
   fi
}

