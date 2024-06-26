#======================================
# This Dockerfile was generated by Ellipsis.
# It should be referenced from your `ellipsis.yaml` config file.
# For more details, see documentation: https://docs.ellipsis.dev
# Test with:      $ docker build -f ellipsis.Dockerfile .
#======================================

FROM ubuntu:20.04
RUN apt-get update && apt-get install -y     git     build-essential

WORKDIR /app
COPY . .
