FROM ubuntu:resolute-20251101
LABEL maintainer="benny.blog.com"
RUN  apt-get -y update && apt-get -y install nginx sudo
ARG USERNAME=nginx
ARG USER_UID=1111
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN chown -R $USERNAME:$USERNAME /var/log/nginx
RUN chown -R $USERNAME:$USERNAME /var/lib/nginx
RUN chown -R $USERNAME:$USERNAME /var/www
RUN chown -R $USERNAME:$USERNAME /etc/nginx
RUN apt-get -y install git
RUN git clone https://github.com/benfairclough/SimpleWebsite.git
RUN cp ./SimpleWebsite/index.html /var/www/html/
RUN sed -i -e "s/welcome/$RANDOM-Welcome/g" /var/www/html/index.html
RUN sed -i 's/.*listen.*:80.*/#listen/g' /etc/nginx/sites-available/default
RUN sed -i 's/www-data/nginx/g' /etc/nginx/nginx.conf
RUN touch /run/nginx.pid
RUN chown $USERNAME:$USERNAME /run/nginx.pid
RUN mkdir /working
WORKDIR /working
EXPOSE 80
USER $USERNAME
#CMD ["sudo","sh","/working/boot.sh"] 
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
