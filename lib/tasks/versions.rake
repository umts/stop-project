# frozen_string_literal: true

require 'paper_trail/frameworks/active_record'

namespace :versions do
  desc 'Reserialize all versions from YAML to JSON'
  task reserialize: :environment do
    PaperTrail::Version.where(object: nil).where.not(old_object: nil).find_each do |version|
      from_yaml = PaperTrail::Serializers::YAML.load(version[:old_object])
      to_json = PaperTrail::Serializers::JSON.dump(from_yaml)
      version.update_column(:object, to_json)
    end
  end
end
