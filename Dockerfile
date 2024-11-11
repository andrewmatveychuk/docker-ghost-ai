FROM ghost:5-alpine AS build

RUN apk add --update --no-cache \
    python3 \
    build-base

WORKDIR /opt/ai

COPY ai-bootstrap.js .

RUN npm init -y && \
    npm install --omit=dev --save applicationinsights && \
    npm install --omit=dev --save applicationinsights-native-metrics

FROM ghost:5-alpine

# Copy the Application Insights artifacts
COPY --from=build /opt/ai /opt/ai

# Inject the scripts to to run before the main Node.Js application
ENV NODE_OPTIONS='--require /opt/ai/ai-bootstrap.js'