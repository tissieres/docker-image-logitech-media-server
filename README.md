# Docker Container for Logitech Media Server

This is a Docker image for running the Logitech Media Server package
(aka SqueezeboxServer) based on the work done by larsks.  The
main difference is the inclusion of dependancies needed to run the 
Google Music plugin as well as a bump in ubuntu and Squeezebox Server
versions.

Run Directly:
```
docker run -d \
           --name lms \
           -p 9000:9000 \
           -p 9090:9090 \
           -p 3483:3483 \
           -p 3483:3483/udp \
           -v /etc/localtime:/etc/localtime:ro \
           -v <local-state-dir>:/srv/squeezebox \
           -v <audio-dir>:/srv/music \
           apnar/logitech-media-server
```
To enable Google Music plugin follow directions here:

https://squeezebox-googlemusic.github.io/squeezebox-googlemusic/

You can skip straight to step 6 of the installation instructions then read the section on usage.

## Note:

If you get the Google Music Plugin seemingly working but get no sound you're likely running
into this bug:

  https://github.com/squeezebox-googlemusic/squeezebox-googlemusic/issues/14

You can fix it by running:
```
docker exec -it lms sed -i 's/::Protocols::HTTP/::Protocols::HTTPS/' /srv/squeezebox/cache/InstalledPlugins/Plugins/GoogleMusic/ProtocolHandler.pm
docker restart lms
```
