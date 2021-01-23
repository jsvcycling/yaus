require 'rom'
require 'rom-repository'
require 'rom-sql'

module Entities
  class Link < ROM::Struct
  end
end

class Links < ROM::Relation[:sql]
  schema infer: true

  struct_namespace Entities
  auto_struct true
end

class LinksRepo < ROM::Repository[:links]
  commands :create

  def find_by_slug(slug)
    links.where(slug: slug).first
  end

  def find_by_target(target)
    links.where(target: target).first
  end
end
