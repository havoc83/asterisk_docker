# Tags
- 13.21-cert3, cert, cert3, certified, 13-cert3 [Dockerfile](https://github.com/havoc83/asterisk_docker/13.21-cert3/Dockerfile)
- 13.21.1, 13.21, 13 [Dockerfile](https://github.com/havoc83/asterisk_docker/13.23.1/Dockerfile)
- 15.16.2, 15 [Dockerfile](https://github.com/havoc83/asterisk_docker/15.6.2/Dockerfile)
- 16.0.1, 16, LTS, Latest [Dockerfile](https://github.com/havoc83/asterisk_docker/16.0.1/Dockerfile)
  
  ## Notes
  Latest will always point to the latest build of the most recent Long term support version. LTS will always point to the most recent long term support version of Asterisk.
  Certified tag will always point to the most recent certified version.

# Reference
- [Asterisk Official Documentation](https://wiki.asterisk.org/wiki/display/AST/Home)  
- [Asterisk Forum](https://community.asterisk.org/)  
- [Asterisk Mailing Lists](https://www.asterisk.org/community/discuss)    

# Purpose
This repository attempts to create production ready Asterisk images, by utilizing multistage builds.  Ubuntu 18 is used as the base image for all images, unless otherwise noted.  All images contain fully functional Asterisk instances however they can also be used as a base to add your own configuration, agi, etc.

# Example 
You will need to run on the host network because of the large number of ports required for rtp traffic.  (By default Asterisk will use ports between 10,000 - 20,000).  
`docker run -d --rm --name="Asterisk-16" --network="host" -v asterisk:/opt/asterisk jrhavlik/asterisk:16.0.1`  