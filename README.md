# BloodHound-Scripts


## Update Owned Nodes
### Description
Simple script to update owned nodes in BloodHound from a file.

### Usage

Simple script to update owned nodes in BloodHound from a file.
The file should contain one node per line. Each node should be described with its FQDN
(e.g. hostname.domain.com). The script is insensitive.
The script requires cypher-shell to be in the PATH.

To display help :
./update_owned_nodes.sh -h
Example: ./update_owned_nodes.sh -u neo4j -p neo4j -d localhost -f ~/nodelist

## Author
Samuel Le Goff

## Acknowledgement
* The update_owned_nodes.sh script is inspired from Chris Farell's cypheroth script  ([@seajay](https://twitter.com/seajay))
