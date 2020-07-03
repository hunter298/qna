# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'google/apis/core/base_service'
require 'google/apis/core/json_representation'
require 'google/apis/core/hashable'
require 'google/apis/errors'

module Google
  module Apis
    module CloudassetV1
      # Cloud Asset API
      #
      # The cloud asset API manages the history and inventory of cloud resources.
      #
      # @example
      #    require 'google/apis/cloudasset_v1'
      #
      #    Cloudasset = Google::Apis::CloudassetV1 # Alias the module
      #    service = Cloudasset::CloudAssetService.new
      #
      # @see https://cloud.google.com/asset-inventory/docs/quickstart
      class CloudAssetService < Google::Apis::Core::BaseService
        # @return [String]
        #  API key. Your API key identifies your project and provides you with API access,
        #  quota, and reports. Required unless you provide an OAuth 2.0 token.
        attr_accessor :key

        # @return [String]
        #  Available to use for quota purposes for server-side applications. Can be any
        #  arbitrary string assigned to a user, but should not exceed 40 characters.
        attr_accessor :quota_user

        def initialize
          super('https://cloudasset.googleapis.com/', '')
          @batch_path = 'batch'
        end
        
        # Creates a feed in a parent project/folder/organization to listen to its
        # asset updates.
        # @param [String] parent
        #   Required. The name of the project/folder/organization where this feed
        #   should be created in. It can only be an organization number (such as
        #   "organizations/123"), a folder number (such as "folders/123"), a project ID
        #   (such as "projects/my-project-id")", or a project number (such as
        #   "projects/12345").
        # @param [Google::Apis::CloudassetV1::CreateFeedRequest] create_feed_request_object
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::Feed] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::Feed]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def create_feed(parent, create_feed_request_object = nil, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:post, 'v1/{+parent}/feeds', options)
          command.request_representation = Google::Apis::CloudassetV1::CreateFeedRequest::Representation
          command.request_object = create_feed_request_object
          command.response_representation = Google::Apis::CloudassetV1::Feed::Representation
          command.response_class = Google::Apis::CloudassetV1::Feed
          command.params['parent'] = parent unless parent.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Deletes an asset feed.
        # @param [String] name
        #   Required. The name of the feed and it must be in the format of:
        #   projects/project_number/feeds/feed_id
        #   folders/folder_number/feeds/feed_id
        #   organizations/organization_number/feeds/feed_id
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::Empty] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::Empty]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def delete_feed(name, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:delete, 'v1/{+name}', options)
          command.response_representation = Google::Apis::CloudassetV1::Empty::Representation
          command.response_class = Google::Apis::CloudassetV1::Empty
          command.params['name'] = name unless name.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Gets details about an asset feed.
        # @param [String] name
        #   Required. The name of the Feed and it must be in the format of:
        #   projects/project_number/feeds/feed_id
        #   folders/folder_number/feeds/feed_id
        #   organizations/organization_number/feeds/feed_id
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::Feed] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::Feed]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def get_feed(name, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:get, 'v1/{+name}', options)
          command.response_representation = Google::Apis::CloudassetV1::Feed::Representation
          command.response_class = Google::Apis::CloudassetV1::Feed
          command.params['name'] = name unless name.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Lists all asset feeds in a parent project/folder/organization.
        # @param [String] parent
        #   Required. The parent project/folder/organization whose feeds are to be
        #   listed. It can only be using project/folder/organization number (such as
        #   "folders/12345")", or a project ID (such as "projects/my-project-id").
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::ListFeedsResponse] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::ListFeedsResponse]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def list_feeds(parent, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:get, 'v1/{+parent}/feeds', options)
          command.response_representation = Google::Apis::CloudassetV1::ListFeedsResponse::Representation
          command.response_class = Google::Apis::CloudassetV1::ListFeedsResponse
          command.params['parent'] = parent unless parent.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Updates an asset feed configuration.
        # @param [String] name
        #   Required. The format will be
        #   projects/`project_number`/feeds/`client-assigned_feed_identifier` or
        #   folders/`folder_number`/feeds/`client-assigned_feed_identifier` or
        #   organizations/`organization_number`/feeds/`client-assigned_feed_identifier`
        #   The client-assigned feed identifier must be unique within the parent
        #   project/folder/organization.
        # @param [Google::Apis::CloudassetV1::UpdateFeedRequest] update_feed_request_object
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::Feed] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::Feed]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def patch_feed(name, update_feed_request_object = nil, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:patch, 'v1/{+name}', options)
          command.request_representation = Google::Apis::CloudassetV1::UpdateFeedRequest::Representation
          command.request_object = update_feed_request_object
          command.response_representation = Google::Apis::CloudassetV1::Feed::Representation
          command.response_class = Google::Apis::CloudassetV1::Feed
          command.params['name'] = name unless name.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Gets the latest state of a long-running operation.  Clients can use this
        # method to poll the operation result at intervals as recommended by the API
        # service.
        # @param [String] name
        #   The name of the operation resource.
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::Operation] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::Operation]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def get_operation(name, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:get, 'v1/{+name}', options)
          command.response_representation = Google::Apis::CloudassetV1::Operation::Representation
          command.response_class = Google::Apis::CloudassetV1::Operation
          command.params['name'] = name unless name.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Batch gets the update history of assets that overlap a time window.
        # For IAM_POLICY content, this API outputs history when the asset and its
        # attached IAM POLICY both exist. This can create gaps in the output history.
        # Otherwise, this API outputs history with asset in both non-delete or
        # deleted status.
        # If a specified asset does not exist, this API returns an INVALID_ARGUMENT
        # error.
        # @param [String] parent
        #   Required. The relative name of the root asset. It can only be an
        #   organization number (such as "organizations/123"), a project ID (such as
        #   "projects/my-project-id")", or a project number (such as "projects/12345").
        # @param [Array<String>, String] asset_names
        #   A list of the full names of the assets.
        #   See: https://cloud.google.com/asset-inventory/docs/resource-name-format
        #   Example:
        #   `//compute.googleapis.com/projects/my_project_123/zones/zone1/instances/
        #   instance1`.
        #   The request becomes a no-op if the asset name list is empty, and the max
        #   size of the asset name list is 100 in one request.
        # @param [String] content_type
        #   Optional. The content type.
        # @param [String] read_time_window_end_time
        #   End time of the time window (inclusive). If not specified, the current
        #   timestamp is used instead.
        # @param [String] read_time_window_start_time
        #   Start time of the time window (exclusive).
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::BatchGetAssetsHistoryResponse] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::BatchGetAssetsHistoryResponse]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def batch_get_assets_history(parent, asset_names: nil, content_type: nil, read_time_window_end_time: nil, read_time_window_start_time: nil, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:get, 'v1/{+parent}:batchGetAssetsHistory', options)
          command.response_representation = Google::Apis::CloudassetV1::BatchGetAssetsHistoryResponse::Representation
          command.response_class = Google::Apis::CloudassetV1::BatchGetAssetsHistoryResponse
          command.params['parent'] = parent unless parent.nil?
          command.query['assetNames'] = asset_names unless asset_names.nil?
          command.query['contentType'] = content_type unless content_type.nil?
          command.query['readTimeWindow.endTime'] = read_time_window_end_time unless read_time_window_end_time.nil?
          command.query['readTimeWindow.startTime'] = read_time_window_start_time unless read_time_window_start_time.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end
        
        # Exports assets with time and resource types to a given Cloud Storage
        # location/BigQuery table. For Cloud Storage location destinations, the
        # output format is newline-delimited JSON. Each line represents a
        # google.cloud.asset.v1.Asset in the JSON format; for BigQuery table
        # destinations, the output table stores the fields in asset proto as columns.
        # This API implements the google.longrunning.Operation API
        # , which allows you to keep track of the export. We recommend intervals of
        # at least 2 seconds with exponential retry to poll the export operation
        # result. For regular-size resource parent, the export operation usually
        # finishes within 5 minutes.
        # @param [String] parent
        #   Required. The relative name of the root asset. This can only be an
        #   organization number (such as "organizations/123"), a project ID (such as
        #   "projects/my-project-id"), or a project number (such as "projects/12345"),
        #   or a folder number (such as "folders/123").
        # @param [Google::Apis::CloudassetV1::ExportAssetsRequest] export_assets_request_object
        # @param [String] fields
        #   Selector specifying which fields to include in a partial response.
        # @param [String] quota_user
        #   Available to use for quota purposes for server-side applications. Can be any
        #   arbitrary string assigned to a user, but should not exceed 40 characters.
        # @param [Google::Apis::RequestOptions] options
        #   Request-specific options
        #
        # @yield [result, err] Result & error if block supplied
        # @yieldparam result [Google::Apis::CloudassetV1::Operation] parsed result object
        # @yieldparam err [StandardError] error object if request failed
        #
        # @return [Google::Apis::CloudassetV1::Operation]
        #
        # @raise [Google::Apis::ServerError] An error occurred on the server and the request can be retried
        # @raise [Google::Apis::ClientError] The request is invalid and should not be retried without modification
        # @raise [Google::Apis::AuthorizationError] Authorization is required
        def export_assets(parent, export_assets_request_object = nil, fields: nil, quota_user: nil, options: nil, &block)
          command = make_simple_command(:post, 'v1/{+parent}:exportAssets', options)
          command.request_representation = Google::Apis::CloudassetV1::ExportAssetsRequest::Representation
          command.request_object = export_assets_request_object
          command.response_representation = Google::Apis::CloudassetV1::Operation::Representation
          command.response_class = Google::Apis::CloudassetV1::Operation
          command.params['parent'] = parent unless parent.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          execute_or_queue_command(command, &block)
        end

        protected

        def apply_command_defaults(command)
          command.query['key'] = key unless key.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
        end
      end
    end
  end
end
