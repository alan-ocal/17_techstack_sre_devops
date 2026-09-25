const axios = require('axios');
const { config, loadConfig } = require('../config');

async function createJsmOperationsAlert(branchName) {
  await loadConfig();

  const response = await axios({
    method: 'POST',
    url: config.jsmOperationsApiEndpoint,
    headers: {
      Authorization: `GenieKey ${config.jsmOperationsApiKey}`,
      'Content-Type': 'application/json',
    },
    data: {
      message: 'Hotfix PR',
      alias: `hotfix-pr-${branchName}`,
      description: `Hotfix Pull Request Was Created, Branch: ${branchName}`,
      priority: 'P1',
      source: 'GitHub hotfix pull request',
    },
  });

  if (response.status < 200 || response.status >= 300) {
    throw new Error(`Could not create JSM Operations alert. Received status: ${response.status}`);
  }

  return response;
}

module.exports = {
  createJsmOperationsAlert,
};