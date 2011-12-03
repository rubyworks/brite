module Brite

  # Access to project metadata as given in `brite.yaml` which
  # is soft linked to the `.ruby` project file.
  #
  # @return [Hash] project metadata
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.dirname(__FILE__) + '/../brite.yml')
    )
  end

  # If constant is missing, check project metadata.
  #
  # @raise [NameError] uninitialized constant
  def self.const_missing(name)
    metadata[name.to_s.downcase] || super(name)
  end

end
