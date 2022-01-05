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

locals {
  timestamp             = formatdate("YYMMDDhhmmss", timestamp())
}

data "archive_file" "source" {
  type                  = "zip"
  source_file           = "${path.module}/index.js"
  output_path           = "${path.module}/tmp/scc-googlechat-${local.timestamp}.zip"
}

resource "google_storage_bucket" "bucket" {
  name                  = var.bucket_name
  location              = var.bucket_location
}

resource "google_storage_bucket_object" "zip" {
  name                  = "source.zip#${data.archive_file.source.output_md5}"
  bucket                = google_storage_bucket.bucket.name
  source                = data.archive_file.source.output_path
}

resource "google_cloudfunctions_function" "function" {
  name                  = var.function_name
  description           = var.function_description
  runtime               = var.function_runtime

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point           = "helloPubSub"
  
  event_trigger {
      event_type        = "google.pubsub.topic.publish"
      resource          = google_pubsub_topic.scc_topic.name
  }

  environment_variables = {
     webHookUrl         = var.gchat_webhook_url
  }
}

resource "google_pubsub_topic" "scc_topic" {
  name                  = var.topic_name
}

resource "google_pubsub_topic_iam_member" "scc_topc_iam" {
  topic                 = google_pubsub_topic.scc_topic.name
  role                  = var.topic_iam_role
  member                = "serviceAccount:${google_scc_notification_config.scc_notification.service_account}"
}

resource "google_scc_notification_config" "scc_notification" {
  config_id             = var.scc_notification_name
  organization          = var.org_id
  description           = var.scc_notification_description
  pubsub_topic          = google_pubsub_topic.scc_topic.id

  streaming_config {
    filter              = var.notification_filter
  }
}


