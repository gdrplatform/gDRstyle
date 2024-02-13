ARG BASE_IMAGE=bioconductor/bioconductor_docker:devel
FROM ${BASE_IMAGE}

# temporary fix
# GitHub token for downloading private dependencies
ARG GITHUB_TOKEN

#================= Check & build package
RUN mkdir -p /mnt/vol
COPY ./ /tmp/gDRstyle/
COPY rplatform/install_repo.R /mnt/vol
RUN R -f /mnt/vol/install_repo.R 

#================= Clean up
RUN sudo rm -rf /mnt/vol/* /tmp/gDRstyle/
