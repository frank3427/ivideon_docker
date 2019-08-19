FROM dorowu/ubuntu-desktop-lxde-vnc

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends wget gpg-agent && apt-get autoclean -y \
     &&  apt-get autoremove -y && rm -Rf /var/lib/apt/lists/*

RUN  wget http://packages.ivideon.com/ubuntu/keys/ivideon.list -O /etc/apt/sources.list.d/ivideon.list \
     &&  bash -c 'wget -O - http://packages.ivideon.com/ubuntu/keys/ivideon.key | sudo apt-key add -' \
     &&  apt-get update &&  apt-get install -y --no-install-recommends ivideon-video-server && apt-get autoclean -y \
     &&  apt-get autoremove -y && rm -rf var/lib/apt/lists/* && rm -Rf /var/cache/apt/*

RUN echo '\n\n\
[program:ivideon]\n\
priority=10\n\
directory=%HOME%\n\
command=/usr/bin/ivideon-server\n\
user=%USER%\n\
environment=DISPLAY=":1",HOME="%HOME%",USER="%USER%"\n\
' >> /etc/supervisor/conf.d/supervisord.conf
COPY startup.sh /
RUN chown root:root /startup.sh 
RUN chmod +x /startup.sh
EXPOSE 8080
EXPOSE 3101
