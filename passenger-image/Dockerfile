FROM debian:jessie

RUN apt-get update && \
      apt-get install -y \
      apt-transport-https \
      ca-certificates

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
      561F9B9CAC40B2F7

RUN echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main" > /etc/apt/sources.list.d/passenger.list

RUN apt-get update && \
      apt-get install -y --no-install-recommends \
      bzip2 \
      curl \
      git \
      libmagickwand-dev \
      libffi-dev \
      libgdbm3 \
      libssl-dev \
      libyaml-dev \
      nginx-extras \
      procps \
      passenger \
      postgresql-client \
      vim \
      zip \
      zlib1g-dev

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.2

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN buildDeps=' \
    autoconf \
    bison \
    gcc \
    libbz2-dev \
    libgdbm-dev \
    libglib2.0-dev \
    libncurses-dev \
    libpq-dev \
    libreadline-dev \
    libxml2-dev \
    libxslt-dev \
    make \
    patch \
  ' \
  && set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/src/ruby \
  && curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
    | tar -xjC /usr/src/ruby --strip-components=1 \
  && cd /usr/src/ruby \
  && autoconf \
  && ./configure --disable-install-doc \
  && make -j"$(nproc)" \
  && make install \
  && rm -r /usr/src/ruby \
  # && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /etc/nginx/main.d
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx_main_d_default.conf /etc/nginx/main.d/default.conf

COPY start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

RUN addgroup --gid 9999 app && \
  adduser --home /home/app --uid 9999 --gid 9999 --disabled-password --gecos "Application" app

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/local/bin/start.sh"]
