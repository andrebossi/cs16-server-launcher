@echo off

netsh interface portproxy add v4tov4 listenport=27015 listenaddress=192.168.0.180 connectport=27015 connectaddress=10.0.75.1

docker container run ^
    -it ^
    --name cs16-server ^
    --restart on-failure ^
    --env-file ./cs16-server-launcher.env ^
    -v d:\server/:/opt/steamcmd/games/cs16 ^
    -v d:\steam:/opt/steamcmd ^
    -p 27015:27015/udp ^
    cs ^
    cs16-server-launcher start
