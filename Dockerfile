FROM ruby:2.7.2
RUN gem install solargraph
COPY Gemfile .
RUN bundle install
