FROM node:19

COPY setup /setup

# Start the server
CMD ["/bin/bash", "/setup/run.sh"]
