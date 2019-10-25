#!/usr/bin/env bash

USAGE="
Simple script to update owned nodes in BloodHound from a file.

Flags:
  -u	Neo4J Username (Required)
  -p	Neo4J Password (Required)
  -d	Fully Qualified Domain Name (Default: localhost)
  -f	Path to file containing the list of nodes (one per line, case
  insensitive (Required)
  -k	If set, nodes are set to not owned. (Default: false)
  -h	Help text and usage example (Optional)

Example: ./update_owned_nodes.sh -u neo4j -p neo4j -d localhost -f ~/nodelist
"


# Check if any flags were set. If not, print out help.
if [ $# -eq 0 ]; then
    echo "$USAGE"
    exit
fi

# Initial variable state
OWNED='TRUE'
DOMAIN='localhost'

# Flag configuration
while getopts "u:p:d:f:kh" FLAG; do
    case $FLAG in
    u)
        USERNAME=$OPTARG
        ;;
    p)
        PASSWORD=$OPTARG
        ;;
    d)
        DOMAIN=$OPTARG
        ;;
    f)
        FILEPATH=$OPTARG
        ;;
    k)
        OWNED='FALSE'
        ;;
    h)
        echo "$USAGE"
        exit
        ;;
    *)
        echo "$USAGE"
        exit
        ;;
    esac
done


if [ -f ${FILEPATH+x} ]; then
    echo "Node list file flag (-f $FILEPATH) is not provided."
    echo "$USAGE"
    exit
elif [ -z ${USERNAME+x} ]; then
    echo "Username flag (-u) is not set."
    echo "$USAGE"
    exit
elif [ -z ${PASSWORD+x} ]; then
    echo "Password flag (-p) is not set."
    echo "$USAGE"
    exit
fi


# Set alias
n4jP="cypher-shell -u $USERNAME -p $PASSWORD --format plain"

# Node names are all uppercase in BloodHound
NODE_LIST="['"$(paste -sd ',' $FILEPATH | sed "s/,/\',\'/g" | tr '[:lower:]' '[:upper:]')"']"
QUERY="MATCH (n) WHERE n.name in "$NODE_LIST" SET n.owned = "$OWNED" RETURN n.name AS Name, n.owned as Owned"

# Launch the query
$n4jP "$QUERY"
