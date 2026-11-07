FROM rocker/shiny:4.4.2
COPY app.R /srv/shiny-server/app.R
ENV MODE=app
EXPOSE 3838
CMD ["/usr/bin/shiny-server"]
