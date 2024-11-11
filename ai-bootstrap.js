const appInsights = require('applicationinsights');
const connectionString = process.env.APPLICATIONINSIGHTS_CONNECTION_STRING;

if (connectionString) {
    console.log('Using Application Insights connection string.');
    appInsights.setup(connectionString)
        .setAutoDependencyCorrelation(true)
        .setAutoCollectRequests(true)
        .setAutoCollectPerformance(true, true)
        .setAutoCollectExceptions(true)
        .setAutoCollectDependencies(true)
        .setAutoCollectConsole(true, true)
        .enableWebInstrumentation(true)
        .start();
} else {
    console.log('WARNING: Application Insights connection string is not set.');
}