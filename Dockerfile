FROM ghost:5-alpine AS build

RUN apk add --update --no-cache \
    python3 \
    build-base

WORKDIR /opt/ai

RUN npm init -y && \
    npm install --omit=dev --save applicationinsights && \
    npm install --omit=dev --save applicationinsights-native-metrics

FROM ghost:5-alpine

# Copy the ai-bootstrap.js file
COPY ai-bootstrap.js /opt/ai/
COPY --from=build /opt/ai /opt/ai

ENV NODE_OPTIONS='--require /opt/ai/ai-bootstrap.js'

# Add MySQL client to check for database availability
RUN apk add --update --no-cache \
    mysql-client

COPY check-db-connection.sh /usr/local/bin
RUN chmod +x /usr/local/bin/check-db-connection.sh

ENTRYPOINT [ "check-db-connection.sh" ]

EXPOSE 2368
CMD ["node", "current/index.js"]