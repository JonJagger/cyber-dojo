FROM rails:4.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN mkdir -p /var/www/cyber-dojo
COPY Gemfile /var/www/cyber-dojo
WORKDIR /var/www/cyber-dojo
RUN bundle install --without development test
COPY . /var/www/cyber-dojo
EXPOSE 3000

CMD [ "bash", "-c", "caches/refresh_all.sh && rails server" ]

# How to build:
#   docker build -t cyberdojofoundation/base  -f Dockerfile ../..
# How to run:
#   docker run --rm \
#              -it \
#              -v /var/run/docker.sock:/var/run/docker.sock \
#              -v /usr/local/bin/docker:/bin/docker \
#              --volumes-from cyber-dojo-katas-data-container \
#              --volumes-from cyber-dojo-tmp-data-container \
#              -p 8080:3000 \
#              cyberdojofoundation/base
