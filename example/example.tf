/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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