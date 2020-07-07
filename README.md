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

https://github.com/squeezebox-googlemusic/squeezebox-googlemusic#installation

You can skip straight to step 7 of the installation instructions then read the section on usage.

## Note:

Recently bumped LMS version to the 8.0 line. See the following from the LMS git page:
https://github.com/Logitech/slimserver#sb-radio-and-logitech-media-server-8

## SB Radio and Logitech Media Server 8+

Unfortunately the latest Squeezebox Radio firmware (7.7.3) comes with a bug which prevents it from connecting correctly to Logitech Media Server 8+. It's version string comparison function fails to recognize 8.0.0 as more recent than 7.7.3. While the bug has been fixed years ago, the fixed firmware never got released. Unfortunately we're at this point not able to build a fixed firmware for distribution.

But there's a patch available, which you can easily install on an existing SB Radio:

* On the Radio go to Settings/Advanced/Applet Installer, install the Patch Installer. The Radio will re-boot.
* Once it's back, go to Settings/Advanced/Patch Installer and install the "Version Comparison Fix".

