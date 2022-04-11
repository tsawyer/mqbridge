# Mqbridge
2022-04-11 version 1.01

Version 1.01 fix for analog mute.

The purpose of mqbridge (multi-qbridge) is to network mutiple Quantars on one host in a central location to ease installation, maintaince and operations. Mqbridge may serve as an alternative to an AstroTAC Comparator in non-voting applications. Mqbridge is a Docker image containing the Quantar to CISCO connector known as qbridge by VK2ERG and P25Gateway by G4KLX. Each container created from the qbridge image independently networks one Quantar allowing for operation excatly like an individual qbridge host. Qbridge and P25Gateway are binary executables compiled to run under an Alpine Linux container. 

If you have an understanding of P25Gateway and docker-compose you can probably look at docker-compose.yml and install without all the details provided here. Otherwise I hope I've shortened your learing curve.

## Installation
- Install docker and docker-compose for your OS. (Get Docker)[https://docs.docker.com/get-docker/].
- Download or clone mqbridge into a directory of your choice. /var/docker is used in these instructions. 

## P25Gateway Settings
- The /var/docker/mqbridge directory containes site1 and site2 directories.
  - If you have used qbridge, DVServer, or looked at the guts of Pi-star you will recognize the files in these directories.
  - You may optionally rename these directories to match your sites after you become fimilar with docker-compose.
  - Each site directory contains the P25Gateway settings and required files for a site.
  - Edit each site directory P25Gateway.ini changing the callsign and startup refelector.
  - Optionally edit private_P25Hosts.txt as desired.

## Docker Compose settings (docker-compose.yml)
- In the `services:` code block there is a `site1:` and a `site2:` code block. These create two Docker containers for two of your sites.
  - The `volumes:` block points to the site directory. The directory on the left side of the : is the host side (ie on your computer). The right side is the directory inside the container. The left side may optionally be changed to match your site. The right side may not be changed.
  - Set the IP of each service to a free address on your network. This is the IP your CISCO router `stun route` will point to. 
- In the `networks:` code block
  - Set the `parent: ` to the name of host main IP as discovered with `ifconfig` or `ip a`. 
  - Set the `- subnet: ` and `gateway` to match your network. 
  
## Running mqbridge
Mqbridge is operated with the `docker-compose` command. You must be in the directory containing docker-compose.yml.
- Mqbridge is started with `docker-compose up -d`. This will start a qbridge and P25Gateway for each site.
  - The first time mqbridge is started docker will download the qbridge image from Docker Hub and build the containers. Subsequent starts will only rebuild any changes.
- Mqbridge is stoped with the `docker-compose down` command.

## Trouble Shooting
- `docker-compose up` (without the -d) will show the containers starting up. Or if started with `docker-compose up -d` you can do `docker-compose logs` or `docker-compose logs -f` to see the same messages. `docker-compose ps` will show a list of running containers. 
- The Docker containers are runing Alpine Linux system. Services are run with Openrc. 
- A container may by entered with `docker-compose exec site ash` where 'site' is the example site1 or site2. The P25Gateway logs are in /var/log/. P25Gateway and qbridge apps are in /opt. 

## Please note
- Qbridge may be changed to the DVServer Quantar Bridge in future mqbridge releases. Also this version of P25Gateway is older and does not have the multiple static talkgroup capability. This may be changed in future mqbridge releases. Both these trade-off were chosen to keep the containers as small as possible.
- There are many ways to do Docker networking and it's a complex subject. This way assumes your host is behind a NAT router and allows docker-compose to give an accessible IP address to each container. Your Quantar network may require a VPN and VLAN. That's beyond the scope of this documentation. 

## Thoughts
- A dashboard supporting all containers wouid be ideal. Perhaps a small dashboard inside each container would be acceptable. If you build such a thing would you please share it with all of us?
- Of course your mileage may vary and none of this is guaranteed to work. But it likely will and for what it's worth there are more lines of documentation here than there are lines of code. It took me about three weeks to figure out Docker, Docker-compose and to build this app. I've found that it's a very nice method of building, distrupiting and operating applications. I know I've deviated from Docker norms, particulary in using openrc. But it seemed silly to create separate qbridge and P25Gateway images per the 'acceptable' method. 
