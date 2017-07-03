FROM rocker/r-base
MAINTAINER Francois Michonneau <francois.michonneau@gmail.com>

RUN apt-get update -qq \
  && apt-get upgrade -y \
  && apt-get install -y \
       git-core \
       libssl-dev \
       libcurl4-gnutls-dev

RUN R -e 'install.packages(c("plumber", "dplyr"))'

RUN R -e 'source("http://install-github.me/fmichonneau/foghorn")'

RUN mkdir -p /app

COPY api.R /app/api.R

EXPOSE 8000

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(port=8000)"]

CMD ["/app/api.R"]