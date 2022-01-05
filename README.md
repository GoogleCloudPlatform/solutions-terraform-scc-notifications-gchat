# Google Cloud SCC Notifications to Google Chat

This repository contains provides example code to create Finding Notifications for Security Command Center, and sends the findings to Google Chat using a Webhook.

The infrastructure is written in Terraform, which will create the following components:

- [SCC Finding Notifications](https://cloud.google.com/security-command-center/docs/how-to-notifications)
- [Pub/Sub Topic](https://cloud.google.com/pubsub)
- [GCS Bucket](https://cloud.google.com/storage/docs/creating-buckets)
- [GCS Object](https://cloud.google.com/storage/docs/json_api/v1/objects)
- [Cloud Function](https://cloud.google.com/functions)

The Cloud Function is written in Node.js which will parse the Pub/Sub event and send the details to a Google Chat Webhook using the a Card message with the Google Chat API.


## Prerequisites 

1. Tested on Terraform v1.0.11 with Google Cloud Provider v4.5.0
2. Google Cloud SDK
3. Enable Cloud Functions API and Cloud Build API
4. Enable Security Command Center
5. Node.js runtime >= 16
6. Create a Google Chat Webhook - info can be found [here](https://developers.google.com/chat/how-tos/webhooks)


## Usage

```ruby
module "scc_notifications" {
    source = "../"

    bucket_name                     = "your-scc-function-bucket"
    bucket_location                 = "ASIA-SOUTHEAST1"
    function_name                   = "scc-notification-gchat"
    function_description            = "SCC Notifications to Google Chat"
    function_runtime                = "nodejs16"
    topic_name                      = "scc-notifications-topic"
    gchat_webhook_url               = "https://chat.googleapis.com/v1/[your-web-hook-url]"
    topic_iam_role                  = "roles/pubsub.publisher"
    scc_notification_name           = "all-active-alerts"
    org_id                          = "01234567890"
    scc_notification_description    = "My Custom Cloud Security Command Center Finding Notification Configuration"
    notification_filter             = "state = \"ACTIVE\""

}
```


*Note: This code sample requires you to hardcode the Webhook URL as an environment variable, using the confidential flag for Terraform. For added security, and to safeguard credentials, consider using Secret Manager with Cloud Functions. For instructions, see [Using secrets](https://cloud.google.com/functions/docs/configuring/secrets) in Cloud Functions documentation.*