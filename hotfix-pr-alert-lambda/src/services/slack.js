// const axios = require('axios');
// const { config, loadConfig } = require('../config');

// async function notifySlack(branchName) {
//   await loadConfig();

//   const payload = {
//     blocks: [
//       {
//         type: 'section',
//         text: {
//           type: 'mrkdwn',
//           text: `*Hotfix PR was created with branch name: ${branchName}*`,
//         },
//       },
//     ],
//   };

//   const response = await axios({
//     method: 'POST',
//     url: config.slackWebhookUrl,
//     data: JSON.stringify(payload),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//   });

//   if (response.status !== 200) {
//     throw new Error(`Couldn't Post To Slack. Received status: ${response.status}`);
//   }

//   return response;
// }

// module.exports = {
//   notifySlack,
// };
