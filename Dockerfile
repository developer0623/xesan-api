FROM xensan/passenger:latest

EXPOSE 80
EXPOSE 443

# remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
COPY docker-conf/nginx.conf /etc/nginx/sites-enabled/xenapi.conf
COPY docker-conf/rails-env.conf /etc/nginx/main.d/rails-env.conf

# Install bundle of gems
WORKDIR /tmp
RUN gem install bundler
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install

VOLUME ["/data"]

# Add the Rails app
COPY . /home/app/xenapi

RUN ln -s /var/log/nginx /home/app/xenapi/log

RUN chown -R app:app /home/app/xenapi

WORKDIR /home/app/xenapi
