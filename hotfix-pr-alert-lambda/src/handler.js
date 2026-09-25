const { getSourceBranch, hasValidPullRequestPayload, getGitHubEventType, shouldCreateHotfixAlert } = require('./utils/event');
// const { notifySlack } = require('./services/slack');
const { createJsmOperationsAlert } = require('./services/jsmOperations');

const SUPPORTED_GITHUB_EVENTS = ['ping', 'pull_request'];

async function handlePRCreation(event) {
  console.log('Event Received', event);

  if (!event || typeof event.body !== 'string') {
    console.log('Event Is Missing The Required body Property');
    return { statusCode: 400 };
  }

  const githubEventType = getGitHubEventType(event);
  if (!SUPPORTED_GITHUB_EVENTS.includes(githubEventType)) {
    console.log('Unsupported Or Missing X-GitHub-Event Header:', githubEventType);
    return { statusCode: 400 };
  }

  if (githubEventType === 'ping') {
    return { statusCode: 200 };
  }

  if (!hasValidPullRequestPayload(event)) {
    console.log('Payload Is Missing The Expected pull_request.head.ref Structure');
    return { statusCode: 400 };
  }

  const branchName = getSourceBranch(event);
  console.log('Branch Name Is:', branchName);

  if (!shouldCreateHotfixAlert(branchName)) {
    console.log('It Is Not A Hotfix Branch And Do Nothing');
    return { statusCode: 200 };
  }

  console.log('Creating JSM Operations Alert');
  // await notifySlack(branchName);
  await createJsmOperationsAlert(branchName);

  return { statusCode: 200 };
}

module.exports = {
  handlePRCreation,
};
