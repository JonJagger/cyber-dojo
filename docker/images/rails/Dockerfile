FROM rails:4.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN mkdir -p /var/www/cyber-dojo
COPY Gemfile /var/www/cyber-dojo
WORKDIR /var/www/cyber-dojo
RUN bundle install --without development test
EXPOSE 3000

