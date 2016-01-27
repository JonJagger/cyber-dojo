FROM ruby:2.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN mkdir -p /var/www/cyber-dojo
COPY Gemfile /var/www/cyber-dojo
WORKDIR /var/www/cyber-dojo
RUN bundle install --without development test
COPY . /var/www/cyber-dojo
EXPOSE 3000

CMD [ "bash", "-c", "rails server" ]
