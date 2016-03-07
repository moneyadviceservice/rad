require 'csv'

module Admin
  module Reports
    class MetricsController < Admin::ApplicationController
      def index
        @snapshots = Snapshot.order(created_at: :desc).page(params[:page]).per(20)
      end

      def show
        @snapshot = Snapshot.find(params[:id])
      end

      def download
        snapshot = Snapshot.find(params[:id])
        send_data snapshot_to_csv(snapshot), filename: csv_filename(snapshot), type: 'text/csv'
      end

      private

      def csv_filename(snapshot)
        date = snapshot.created_at
        "snapshot-#{date.year}-#{date.month}-#{date.day}.csv"
      end

      def csv_headers
        %w(metric value)
      end

      def snapshot_to_csv(snapshot)
        CSV.generate do |csv|
          csv << csv_headers

          snapshot.metrics_in_order.each do |attr|
            csv << [I18n.t("snapshot.attributes.#{attr}"), snapshot[attr]]
          end
        end
      end
    end
  end
end
