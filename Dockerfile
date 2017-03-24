FROM debian:latest

# Set default environment variables
ENV PORT=80

EXPOSE ${PORT}

# Install dependencies
RUN apt-get update && apt-get install -y ruby rubygems
RUN gem install bundle

# Add files to image
RUN mkdir /sentrytransform
ADD . /sentrytransform
WORKDIR /sentrytransform
RUN bundle install

CMD bundle exec rackup --host "0.0.0.0" -p ${PORT}
