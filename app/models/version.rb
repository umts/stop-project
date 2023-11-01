# frozen_string_literal: true

class Version < ApplicationRecord
  include PaperTrail::VersionConcern

  # TODO: Remove after migration.
  def object
    return super unless super.nil?
    return if old_object.nil?

    PaperTrail::Serializers::JSON.dump(PaperTrail::Serializers::YAML.load(old_object))
  end

  # TODO: Remove after migration.
  def object_changes
    return super unless super.nil?
    return if old_object_changes.nil?

    PaperTrail::Serializers::JSON.dump(PaperTrail::Serializers::YAML.load(old_object_changes))
  end
end
