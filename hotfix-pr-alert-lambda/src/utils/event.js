function safeParseBody(event) {
  if (!event || typeof event.body !== 'string') {
    return null;
  }

  try {
    return JSON.parse(event.body);
  } catch (error) {
    return null;
  }
}

function getSourceBranch(event) {
  const payload = safeParseBody(event);
  return payload && payload.pull_request && payload.pull_request.head ? payload.pull_request.head.ref : undefined;
}

function hasValidPullRequestPayload(event) {
  const payload = safeParseBody(event);
  return Boolean(payload && payload.pull_request && payload.pull_request.head && payload.pull_request.head.ref);
}

function getGitHubEventType(event) {
  const headers = (event && event.headers) || {};
  return headers['X-GitHub-Event'] || headers['x-github-event'];
}

function isGitHubPingRequest(event) {
  return getGitHubEventType(event) === 'ping';
}

function shouldCreateHotfixAlert(branchName) {
  return typeof branchName === 'string' && branchName.includes('hotfix');
}

module.exports = {
  getSourceBranch,
  hasValidPullRequestPayload,
  getGitHubEventType,
  isGitHubPingRequest,
  shouldCreateHotfixAlert,
};
