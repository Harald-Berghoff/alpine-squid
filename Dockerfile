# start with alpineimage
FROM alpine

#Install squid and clean the cache in the same step

RUN apk add squid && \
    rm -rf /var/cache/apk/* 

# This will use port 631
EXPOSE 3128/tcp

# Copy the entrypoint script and make sure it's executable.
# Could have been included into step above, but isn't a real
# change in image size
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Set the enty point
ENTRYPOINT ["/sbin/entrypoint.sh"]
