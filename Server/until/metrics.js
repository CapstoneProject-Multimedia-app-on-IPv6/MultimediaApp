import express from 'express';
import client from 'prom-client';

export const startMetricsServer = () => {
  const app = express();

  // Enable default metrics
  client.collectDefaultMetrics();

  // Expose the /metrics endpoint
  app.get('/metrics', async (req, res) => {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  });

  // Start the server
  const port = 9091;
  app.listen(port, () => {
    console.log(`Metrics server listening on http://localhost:${port}/metrics`);
  });
};