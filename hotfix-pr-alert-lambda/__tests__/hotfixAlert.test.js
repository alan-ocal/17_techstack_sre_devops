const { getSourceBranch, isGitHubPingRequest, shouldCreateHotfixAlert } = require('../src/utils/event');
const { handlePRCreation } = require('../src/handler');
// const slackService = require('../src/services/slack');
const jsmOperationsService = require('../src/services/jsmOperations');

// jest.mock('../src/services/slack', () => ({
//   notifySlack: jest.fn(),
// }));

jest.mock('../src/services/jsmOperations', () => ({
  createJsmOperationsAlert: jest.fn(),
}));

describe('hotfix alert utilities', () => {
  test('gets the source branch from a GitHub PR event', () => {
    const event = {
      body: JSON.stringify({
        pull_request: {
          head: {
            ref: 'hotfix/FIX-123',
          },
        },
      }),
    };

    expect(getSourceBranch(event)).toBe('hotfix/FIX-123');
  });

  test('detects GitHub ping requests', () => {
    const event = {
      headers: { 'X-GitHub-Event': 'ping' },
      body: JSON.stringify({ zen: 'Keep it logically awesome.' }),
    };

    expect(isGitHubPingRequest(event)).toBe(true);
  });

  test('flags only hotfix branches', () => {
    expect(shouldCreateHotfixAlert('hotfix/urgent-fix')).toBe(true);
    expect(shouldCreateHotfixAlert('feature/new-ui')).toBe(false);
  });
});

describe('handlePRCreation', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('sends Slack and JSM Operations alerts for hotfix pull requests', async () => {
    const event = {
      headers: { 'X-GitHub-Event': 'pull_request' },
      body: JSON.stringify({
        pull_request: {
          head: {
            ref: 'hotfix/urgent-fix',
          },
        },
      }),
    };

    await handlePRCreation(event);

    // expect(slackService.notifySlack).toHaveBeenCalledWith('hotfix/urgent-fix');
    expect(jsmOperationsService.createJsmOperationsAlert).toHaveBeenCalledWith('hotfix/urgent-fix');
  });

  test('does not notify for non-hotfix pull requests', async () => {
    const event = {
      headers: { 'X-GitHub-Event': 'pull_request' },
      body: JSON.stringify({
        pull_request: {
          head: {
            ref: 'feature/new-ui',
          },
        },
      }),
    };

    await handlePRCreation(event);

    // expect(slackService.notifySlack).not.toHaveBeenCalled();
    expect(jsmOperationsService.createJsmOperationsAlert).not.toHaveBeenCalled();
  });
});
