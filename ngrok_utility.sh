#!/bin/bash
ngrok_version="2"
api_url="https://api.ngrok.com/"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'


function ctrl_c() {
    echo -e "\nExiting..."
    untrap_ctrl_c
    exit 0
}
function untrap_ctrl_c() {
    trap - INT
}

initialize(){
	echo -e  "Before continuing, please make sure you have a valid ngrok token.\nIf you don't have one, follow the instructions to create an account and obtain a token."
	echo -e " \nVisit the ngrok website at https://ngrok.com/.\n 1)Sign up for an account if you don't already have one.\n 2)Log in to your ngrok account. \n 3)Go to the "Auth" section or the "Your Authtoken" page\n 4)Copy the authtoken provided."
	echo
	read -p "Press 'y' to continue once you have a token: " response
	if [[ "$response" =~ ^(yes|y|our|yesto)$ ]]; then
 		 :
	else
 		 echo -e "${RED}Error:${RESET} Invalid response. Exiting.."
		  exit 1
	fi
	echo -e "Enter your ngrok token: "
	read -rs token
	./ngrok config add-authtoken $token 2> /dev/null
	token_is_valid
	if ! [[ ${#token} -ge 45  ]]; then
	    echo -e "${RED}Warning:${RESET} Invalid token length."
	    exit 1
	fi
	echo -e "\nEnter your ngrok API Key: "
	read -rs apikey
	
	if ! [[ ${#apikey} -ge 29 ]]; then
	    echo -e "${RED}Warning:${RESET} Invalid API key length"
	    exit 1
	fi
	
	
	max_attempts=3
	attempts=0

	while [[ $attempts -lt $max_attempts ]]; do
	    read -p "Enter the port to expose: " serv
	    if [[ $serv =~ ^[0-9]+$ ]]; then
		if (( serv >= 1 && serv <= 65535 )); then
		    echo -e "${GREEN}Port:${RESET} $serv is valid."
		    break  
		fi
	    fi
	    attempts=$((attempts + 1))
	    echo -e "${YELLOW}Warning:${RESET} Invalid input: Please enter a numeric value within the range of 1-65535."
	done

	if [[ $attempts -eq $max_attempts ]]; then
	    echo -e "${RED}Warning:${RESET} Maximum attempts reached. Exiting..."
	    exit 1
	fi
	
	read -rp "Enter protocol (TCP or UDP): " protocol
	# Convert the entered protocol to lowercase
	protocol=$(echo "$protocol" | tr '[:upper:]' '[:lower:]')

	# Check if the protocol is valid
	if [[ "$protocol" == "tcp" || "$protocol" == "udp" ]]; then
	   echo -e "${GREEN}Valid${RESET} protocol: $protocol"
	    echo -e "\n"
	else
	    echo "Invalid protocol. Only TCP or UDP is allowed."
	    echo -e "\n"
	    exit 1
	fi
	
}
run_in_debug_mode() {
    echo -e "${YELLOW}Warning:${RESET} ****** Running in debug mode ******"
    set -x
   }
show_help() {
	echo "Usage: ngrok_utility.sh [option] [option2]"
	echo "Options:"
	echo "  -r, --run 	 To run the ngrok suite"
	echo "  -i, --sess-info  Extract session info"
	echo "  -k, --kill       Destroy ngrok process"
	echo "  -h, --help       Show help"
	echo "  -d, --debug      To run the script in debug mode PS: only works with -r | --run"
	echo "      --json       To print informations from endpoint"
}

check_install_ngrok() {
    if command -v ngrok >/dev/null 2>&1; then
        echo "ngrok is already installed."
        ./ngrok config add-authtoken "$token"
        ./ngrok update
        return 1
    else
        echo -e "${YELLOW}Locating:${RESET}  ngrok..."
        echo -e  "\n"
        ngrok_paths=$(find / -name "ngrok" -type f -executable 2>/dev/null)

        if [ -z "$ngrok_paths" ]; then
            echo "ngrok is not installed. Installing ngrok..."
            wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
            tar xfz ngrok-v3-stable-linux-amd64.tgz
            rm ngrok-v3-stable-linux-amd64.tgz
            echo "Updating ngrok..."
            ./ngrok update
            return 1
        fi

        if [ "$(echo "$ngrok_paths" | wc -l)" -eq 1 ]; then
            selected_path=$(echo "$ngrok_paths")
            echo "Navigating to $selected_path"
            cd "$(dirname "$selected_path")"
            ./ngrok update
            return 1
        else
            max_attempts=3
            attempts=0
            echo "Multiple installations of ngrok found:"
            IFS=$'\n' read -rd '' -a ngrok_paths <<< "$ngrok_paths"
            while [[ $attempts -lt $max_attempts ]]; do
                for i in "${!ngrok_paths[@]}"; do
                    echo "$((i+1)). ${ngrok_paths[i]}"
                done
                echo
                read -rp "Please enter the number corresponding to the ngrok installation path: " selected_index

                if [[ $selected_index =~ ^[1-9][0-9]*$ ]] && [[ $selected_index -le ${#ngrok_paths[@]} ]]; then
                    selected_path="${ngrok_paths[selected_index-1]}"
                    break
                fi

                attempts=$((attempts + 1))
                echo "Invalid input: Please enter a valid number from the paths above"
            done

            if [[ $attempts -eq $max_attempts ]]; then
                echo -e "${YELLOW} Maximum ${RESET}  attempts reached. Exiting..."
                exit 1
            fi

            if [ -x "$selected_path" ]; then
                echo -e "${GREEN}Navigating ${RESET}  to $selected_path"
                cd "$(dirname "$selected_path")"
                ./ngrok update
                return 1
            else
                echo -e "${YELLOW}Invalid ${RESET} path. Exiting..."
                exit 1
            fi
        fi
    fi
}
json_out() {
    if  pidof -x ./ngrok >/dev/null; then
        curl http://127.0.0.1:4040/api/tunnels 2>/dev/null | jq
    else
        echo -e "${YELLOW}Warning:${RESET} Run the script first"
    fi
}
install_package_if_not_installed() {
    echo -e "\n"
    echo -e "${YELLOW}Warning:${RESET} Checking packages"
    echo -e "\n"
    #Check for ipcalc
    if ! command -v ipcalc &> /dev/null; then
    	read -e -p "$(tput setaf 3)Warning:$(tput sgr0) The 'ipcalc' command is not installed. Do you want to install it? (y/n): " INSTALL_IPCALC
    	echo -e "\n"
    if [[ $INSTALL_IPCALC == "y" ]]; then
        if [ -f "/etc/debian_version" ]; then
            echo -e "${GREEN}Warning:${RESET} Detected Debian-based system."
             apt-get update
 	     apt-get install -y ipcalc
        elif [ -f "/etc/fedora-release" ]; then
            echo -e "${YELLOW}Warning:${RESET} Detected Fedora-based system."
             apt-get update
             dnf install -y ipcalc
        else
          echo -e "${RED}Error:${RESET}  Unsupported operating system. Unable to install 'ipcalc'. Exiting."
            exit 1
        fi
    else
        echo -e "${RED}Error:${RESET} The 'ipcalc' command is required for IP address and CIDR notation validation. Exiting."
        exit 1
    fi
fi
    
    

}

run_ngrok_in_standalone() {
	nohup ./ngrok $protocol $serv &
	echo -e "\n\n"
	echo -e "${GREEN}Success:${RESET} Script is running "
	
}

token_is_valid()
{
     output=$(timeout 5s ./ngrok tcp 22 2>&1)
     #pkill -9 -f "./ngrok"
     #kill -9 $(ps aux | grep ./ngrok | grep -v grep | cut -d" " -f9)
     if [[ $output == *"authentication failed"* ]]; then
         echo -e "${RED}Error:${RESET}  Invalid token: $token"
        read -e -p "$(tput setaf 3)Warning:$(tput sgr0) please enter a valid token: " corrected_token
         ./ngrok config add-authtoken $corrected_token
        return 1
     fi
}


extract_sess_info() {
status_code=$(curl -s -o output -w "%{http_code}" http://127.0.0.1:4040/api/tunnels) 
if [ "$status_code" -eq 200 ]; then
  	variable=$(curl http://127.0.0.1:4040/api/tunnels 2>/dev/null | jq '.tunnels[0].public_url' | tr '//":' ' ' | sed 's/tcp//1') 
	echo "Public IP address :  $(echo "$variable" | awk '{print $1}')"
	echo "Forwarding Port :  $(echo "$variable" | awk '{print $2}')"
	rm output
else
	echo -e "${YELLOW}Warning:${RESET} Exiting... API endpoint is unreachable" 
	exit 0
fi

}

secure_service() {
if [ run_ngrok_in_standalone ];then
	if ! command -v ipcalc &> /dev/null; then
	    read -p "The 'ipcalc' command is not installed. Do you want to install it? (y/n): " INSTALL_IPCALC

	    if [[ $INSTALL_IPCALC == "y" ]]; then
		if [ -f "/etc/debian_version" ]; then
		    echo "Detected Debian-based system."
		      apt-get update
   		      apt-get install -y ipcalc
		elif [ -f "/etc/fedora-release" ]; then
		    echo "Detected Fedora-based system."
		     dnf install -y ipcalc
		else
		    echo "Unsupported operating system. Unable to install 'ipcalc'. Exiting."
		    exit 1
		fi
	    else
		echo "The 'ipcalc' command is required for IP address and CIDR notation validation. Exiting."
		exit 1
	    fi
	fi

	read -p "Do you want to grant access to a single IP or a network with CIDR notation? (s/n): " OPTION

	if [[ $OPTION == "s" ]]; then
	    read -p "Enter the IP address: " IP_ADDRESS

	    if [[ ! $IP_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "Invalid IP address format. Exiting."
		exit 1
	    fi
	elif [[ $OPTION == "n" ]]; then
	    read -p "Enter the network address (e.g., 192.168.0.0): " NETWORK_ADDRESS
	    read -p "Enter the CIDR mask (e.g., 24): " CIDR_MASK

	    if [[ ! $NETWORK_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "Invalid network address format. Exiting."
		exit 1
	    fi

	    if [[ ! $CIDR_MASK =~ ^[0-9]+$ ]] || (( CIDR_MASK < 0 || CIDR_MASK > 32 )); then
		echo "Invalid CIDR mask value. Exiting."
		exit 1
	    fi

	    IP_ADDRESS="$NETWORK_ADDRESS/$CIDR_MASK"
	else
	    echo "Invalid option. Exiting."
	    exit 1
	fi

	if ! ipcalc -c "$IP_ADDRESS"; then
	    echo "Invalid IP address or CIDR notation. Exiting."
	    exit 1
	fi

	read -p "Enter the service port: " SERVICE_PORT

	if [ -f "/etc/debian_version" ]; then
	    echo "Detected Debian-based system."

	    existing_rules=$(iptables -L INPUT -n --line-numbers --verbose | grep -e "Rule[0-9]*" | awk '{print $1}')

	    if [ -n "$existing_rules" ]; then
		echo "Existing rules with the script's comment found:"
		iptables -L INPUT -n --line-numbers --verbose | grep -e "Rule[0-9]*"

		read -p "Do you want to remove the existing rules? (y/n): " REMOVE_RULES

		if [[ $REMOVE_RULES == "y" ]]; then
	  iptables -F

		    echo "Existing rules removed."
		else
		    echo "Exiting without making changes."
		    exit 0
		fi
	    else
		echo "No existing rules found."
	    fi


	    highest_rule_num=$(iptables -L INPUT -n --line-numbers --verbose | grep -e "Rule[0-9]*" | awk '{print $1}' | sed 's/Rule//g' | sort -rn | head -n 1)

	    if [[ -z $highest_rule_num ]]; then
		rule_num=1
	    else
		rule_num=$((highest_rule_num + 1))
	    fi

	    comment="Rule$rule_num"


	    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	    iptables -A INPUT -i lo -j ACCEPT
	    iptables -A INPUT -p tcp -s "$IP_ADDRESS" --dport "$SERVICE_PORT" -m comment --comment "$comment"  -j ACCEPT
	    iptables -A INPUT -p tcp --dport "$SERVICE_PORT" -m comment --comment "$comment" -j DROP

	    echo "Iptables rules have been updated."
	elif [ -f "/etc/fedora-release" ]; then
	    echo "Detected Fedora-based system."

	    existing_rules=$(firewall-cmd --permanent --direct --get-all-rules | grep -e "Rule[0-9]*" | awk '{print $1}')

	    if [ -n "$existing_rules" ]; then
		echo "Existing rules with the script's comment found:"
		firewall-cmd --permanent --direct --get-all-rules | grep -e "Rule[0-9]*"

		read -p "Do you want to remove the existing rules? (y/n): " REMOVE_RULES

		if [[ $REMOVE_RULES == "y" ]]; then
		    for rule_num in $existing_rules; do
		        firewall-cmd --permanent --direct --remove-rule $rule_num
		    done
		    firewall-cmd --reload
		    echo "Existing rules removed."
		else
		    echo "Exiting without making changes."
		    exit 0
		fi
	    else
		echo "No existing rules found."
	    fi
	    highest_rule_num=$(firewall-cmd --permanent --direct --get-all-rules | grep -e "Rule[0-9]*" | awk '{print $1}' | sed 's/Rule//g' | sort -rn | head -n 1)

	    if [[ -z $highest_rule_num ]]; then
		rule_num=1
	    else
		rule_num=$((highest_rule_num + 1))
	    fi

	    comment="Rule$rule_num"
	    firewall-cmd --permanent --zone=public --add-rich-rule="rule family=ipv4 source address=$IP_ADDRESS port protocol=tcp port=$SERVICE_PORT accept"
	    firewall-cmd --reload
	    echo "Firewalld rules have been updated."
	else
	    echo "Unsupported operating system."
	    exit 1
	fi
else
	echo "Ngrok is not running. Exiting."
	return 0
	exit 0
	
fi
}

main() {
	 if [[ $EUID -ne 0 ]]; then
		echo "This script requires root privileges. Please run it with sudo."
		exit 1
	    fi
	if [[ $# -eq 0 ]]; then
		show_help
		exit 1
	fi
trap ctrl_c INT
	case $1 in
		-k | --kill)
			if  ! pidof -x ./ngrok >/dev/null; then
				echo -e "${YELLOW}Warning:${RESET} No ngrok process is currently running."
			else
				echo -e "${GREEN}RUNNING:${RESET} Stopping ngrok..." 
				pkill  -f "./ngrok"  >/dev/null 2>&1
			fi
			;;
		-i | --sess-info)
			extract_sess_info
			;;
	
		-S | --secure)
			if pidof -x ./ngrok >/dev/null ; then
				secure_service
			else
				echo -e "${YELLOW}Warning:${RESET} You need to run the script"
				exit 1
			fi
			;;
		-h|--help)
			show_help
			;;
		-r | --run)
			
		if [[ $# -ge 2 && ($2 == "--debug" || $2 == "-d" ) ]]; then
    			if pidof -x ./ngrok >/dev/null > /dev/null; then
     		   		echo -e "${YELLOW}Warning:${RESET} ngrok process is already running. Please stop the process before running in debug mode."
 	   		else
				run_in_debug_mode
				initialize
				check_install_ngrok
				install_package_if_not_installed nohup ipcalc
				run_ngrok_in_standalone
    			fi
		elif pidof -x ./ngrok >/dev/null > /dev/null; then
     		   	echo -e "${YELLOW}Warning:${RESET} ngrok process is already running. Please stop the process before running in debug mode."
		else
		    initialize
		    check_install_ngrok
		    install_package_if_not_installed nohup ipcalc
		    run_ngrok_in_standalone
		fi
			;;
		--json) 
			json_out
			;;
		*)
			echo -e "${RED}Error:${RESET} Wrong param $1"
			show_help
			exit 1
		
	esac


}

main "$@"
