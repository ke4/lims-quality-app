require 'lims-core/resource'

module Lims::QualityApp
  class GelImage
    include Lims::Core::Resource

    attribute :gel_uuid, String, :required => true
    attribute :image, String, :required => true
    attribute :filename, String, :required => false
    attribute :scores, Hash, :required => false, :default => {}

    def attributes
      {
        :gel_uuid => gel_uuid, 
        :image => image, 
        :filename => filename
      }
    end
  end
end
