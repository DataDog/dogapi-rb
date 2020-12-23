require_relative '../spec_helper'

describe Dogapi::Client do
  SLO_ID = '42424242424242424242424242424242'.freeze
  SLO_CORRECTION_ID = '12121212121212121212121212121212'.freeze
  TIMEZONE = 'UTC'.freeze
  CATEGORY = 'Deployment'.freeze
  DESCRIPTION = 'Planned maintenance.'.freeze
  UPDATED_DESCRIPTION = 'Weekly deployment.'.freeze
  START_DT = 1604966400
  END_DT = 1605133742

  describe '#create_slo_correction' do
    it_behaves_like 'an api method',
                    :create_slo_correction, [SLO_ID, TIMEZONE, CATEGORY, {
                      description: DESCRIPTION,
                      start_dt: START_DT,
                      end_dt: END_DT
                    }],
                    :post, '/slo/correction', 'slo_id' => SLO_ID, 'timezone' => TIMEZONE, 'category' => CATEGORY,
                                   'description' => SLO_DESCRIPTION, 'start_dt': START_DT, 'end_dt': END_DT
  end

  describe '#update_slo_correction' do
    it_behaves_like 'an api method',
                    :update_slo_correction, [SLO_CORRECTION_ID, { description: UPDATED_DESCRIPTION }],
                    :put, "/slo/correction/#{SLO_CORRECTION_ID}", 'description' => UPDATED_DESCRIPTION
  end

  describe '#get_all_slo_corrections' do
    it_behaves_like 'an api method',
                    :get_all_slo_corrections, nil,
                    :get, "/slo/correction"
  end

  describe '#get_slo_correction' do
    it_behaves_like 'an api method',
                    :get_slo_correction, [SLO_CORRECTION_ID],
                    :get, "/slo/correction/#{SLO_CORRECTION_ID}"
  end

  describe '#delete_slo_correction' do
    it_behaves_like 'an api method',
                    :delete_slo_correction, [SLO_CORRECTION_ID],
                    :delete, "/slo/correction/#{SLO_CORRECTION_ID}"
  end
end
