FROM ruby:2.6-slim as slate-build

WORKDIR /srv/slate

VOLUME /srv/slate/build
VOLUME /srv/slate/source

COPY Gemfile .
COPY Gemfile.lock .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        nodejs \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /srv/slate

RUN chmod +x /srv/slate/slate.sh
RUN /srv/slate/slate.sh build

FROM alpine:latest

RUN apk add --update \
    lighttpd \
  && rm -rf /var/cache/apk/*

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=slate-build /srv/slate/build /var/www
RUN adduser www-data -G www-data -H -s /bin/false -D

EXPOSE 80

ENTRYPOINT ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
