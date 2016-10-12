FROM debian:testing

WORKDIR /srv/timing

COPY dpkg_requirements.txt ./
RUN apt-get update && apt-get install --assume-yes --no-install-recommends $(cat dpkg_requirements.txt)

RUN gem install bundler --pre --no-document
COPY Gemfile ./
RUN bundle install

EXPOSE 80

CMD bin/rails db:migrate && chmod +w db/development.sqlite3 && bin/rails server -b 0.0.0.0 -p 80
