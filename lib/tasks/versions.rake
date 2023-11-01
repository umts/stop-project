# frozen_string_literal: true

# TODO: Remove after migration.
namespace :versions do
  desc 'Reserialize version data as JSON'
  task reserialize: :environment do
    unmigrated = <<~SQL.squish
      (`versions`.`old_object` IS NOT NULL AND `versions`.`object` IS NULL) OR
      (`versions`.`old_object_changes` IS NOT NULL AND `versions`.`object_changes` IS NULL)
    SQL

    Version.where(unmigrated).find_each do |version|
      if version[:old_object] && version[:object].nil?
        from_yaml = PaperTrail::Serializers::YAML.load(version[:old_object])
        to_json = PaperTrail::Serializers::JSON.dump(from_yaml)
        version.update_column(:object, to_json)
      end

      if version[:old_object_changes] && version[:object_changes].nil?
        from_yaml = PaperTrail::Serializers::YAML.load(version[:old_object_changes])
        to_json = PaperTrail::Serializers::JSON.dump(from_yaml)
        version.update_column(:object_changes, to_json)
      end
    end
  end
end
