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

# Add wait-for-it for better startup handling with external database service
COPY wait-for-it.sh ./wait-for-it.sh
COPY docker-entrypoint.sh ./docker-entrypoint.sh

RUN chmod +x ./wait-for-it.sh ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["node", "current/index.js"]
