const config = {
  jsmOperationsApiKey: process.env.JSM_OPERATIONS_API_KEY,
  jsmOperationsApiEndpoint: process.env.JSM_OPERATIONS_API_ENDPOINT,
};

async function loadConfig() {
  validateConfig();
  return config;
}

function validateConfig() {
  const missing = Object.entries(config)
    .filter(([, value]) => !value)
    .map(([key]) => key);

  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }

  return config;
}

module.exports = {
  config,
  loadConfig,
  validateConfig,
};
