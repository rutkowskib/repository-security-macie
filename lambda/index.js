const AWS = require('aws-sdk');

const handler = async () => {
  const macie = new AWS.Macie2({ apiVersion: '2020-01-01' });
  const date = new Date().toISOString();
  await macie.createClassificationJob({
    clientToken: date,
    jobType: 'ONE_TIME',
    name: `macie_report_${date}`,
    s3JobDefinition: {
      bucketDefinitions: [{
        accountId: process.env.ACCOUNT_ID,
        buckets: [ process.env.BUCKET_NAME ]
      }],
    },
    customDataIdentifierIds: [ process.env.DATA_IDENTIFIER_ID ],
  }).promise();
};

module.exports = {
  handler,
};