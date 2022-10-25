FROM arkadiuszgladki/gdr_shiny:0.08

# temporary fix
# GitHub token for downloading private dependencies
ARG GITHUB_TOKEN

#================= Check & build package
RUN mkdir -p /mnt/vol
COPY ./ /tmp/gDRstyle/
RUN R -f /mnt/vol/install_repo.R 

#================= Clean up
RUN sudo rm -rf /mnt/vol/* /tmp/gDRstyle/
